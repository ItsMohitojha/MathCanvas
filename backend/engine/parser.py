import logging
import re

from sympy.parsing.sympy_parser import (
    implicit_multiplication_application,
    parse_expr,
    standard_transformations,
)

from core.errors import ParseError

logger = logging.getLogger(__name__)


def convert_fractions(latex_str: str) -> str:
    """Recursively converts \frac{a}{b} into ((a)/(b)). Handles nested fractions."""
    while r"\frac" in latex_str:
        start_idx = latex_str.find(r"\frac")
        if start_idx == -1:
            break

        # Find the first brace
        brace1_start = latex_str.find("{", start_idx)
        if brace1_start == -1:
            break

        # Find matching closing brace for numerator
        brace_count = 1
        brace1_end = -1
        for i in range(brace1_start + 1, len(latex_str)):
            if latex_str[i] == "{":
                brace_count += 1
            elif latex_str[i] == "}":
                brace_count -= 1
                if brace_count == 0:
                    brace1_end = i
                    break

        if brace1_end == -1:
            break

        # Find opening brace for denominator (skip whitespace)
        brace2_start = -1
        for i in range(brace1_end + 1, len(latex_str)):
            if latex_str[i] == "{":
                brace2_start = i
                break
            elif not latex_str[i].isspace():
                break

        if brace2_start == -1:
            break

        # Find matching closing brace for denominator
        brace_count = 1
        brace2_end = -1
        for i in range(brace2_start + 1, len(latex_str)):
            if latex_str[i] == "{":
                brace_count += 1
            elif latex_str[i] == "}":
                brace_count -= 1
                if brace_count == 0:
                    brace2_end = i
                    break

        if brace2_end == -1:
            break

        num = latex_str[brace1_start + 1 : brace1_end]
        den = latex_str[brace2_start + 1 : brace2_end]

        replacement = f"(({num})/({den}))"
        latex_str = latex_str[:start_idx] + replacement + latex_str[brace2_end + 1 :]

    return latex_str


def clean_latex(latex_str: str) -> str:
    """Preprocesses LaTeX strings into SymPy-compatible syntax."""
    if not latex_str:
        return ""

    # Remove LaTeX spacing commands
    cleaned = re.sub(r"\\[,;! ]|\\quad|\\qquad", "", latex_str)

    # Mathematical operators
    cleaned = cleaned.replace(r"\cdot", "*")
    cleaned = cleaned.replace(r"\times", "*")
    cleaned = cleaned.replace(r"\div", "/")

    # Convert LaTeX brackets/parentheses
    cleaned = cleaned.replace(r"\left(", "(").replace(r"\right)", ")")
    cleaned = cleaned.replace(r"\left[", "[").replace(r"\right]", "]")
    cleaned = cleaned.replace(r"\left\{", "{").replace(r"\right\}", "}")

    # Convert standard trig and mathematical functions
    cleaned = re.sub(r"\\(sin|cos|tan|cot|sec|csc|log|ln|exp|sqrt)", r"\1", cleaned)

    # Convert fractions
    cleaned = convert_fractions(cleaned)

    # Convert exponents: ^ -> **
    cleaned = cleaned.replace("^", "**")

    # Handle ^{...} -> **(...)
    def replace_exponent_braces(match):
        return f"**({match.group(1)})"

    cleaned = re.sub(r"\*\*\{([^}]+)\}", replace_exponent_braces, cleaned)

    # Convert variable notations if any, e.g., \pi -> pi
    cleaned = cleaned.replace(r"\pi", "pi")
    cleaned = cleaned.replace(r"\theta", "theta")
    cleaned = cleaned.replace(r"\alpha", "alpha")
    cleaned = cleaned.replace(r"\beta", "beta")
    cleaned = cleaned.replace(r"\gamma", "gamma")

    # Strip remaining backslashes
    cleaned = cleaned.replace("\\", "")

    return cleaned.strip()


def parse_to_sympy_str(latex_str: str) -> str:
    """Converts a LaTeX expression string to a SymPy-compatible string.

    Returns:
        A SymPy parsable expression string (e.g. 'Eq(2*x + 4, 8)' or '2*x + 4').
    """
    cleaned = clean_latex(latex_str)

    sympy_str = cleaned
    if "=" in cleaned:
        parts = cleaned.split("=")
        if len(parts) == 2:
            sympy_str = f"Eq({parts[0].strip()}, {parts[1].strip()})"
        else:
            raise ParseError(
                "Multiple '=' characters found in equation", {"expression": latex_str}
            )

    transformations = standard_transformations + (implicit_multiplication_application,)

    try:
        # Check components first if equation, as `parse_expr` might not error on certain malformed equations if not parsed individually.
        if "=" in cleaned:
            parts = cleaned.split("=")
            if len(parts) == 2:
                parse_expr(parts[0].strip(), transformations=transformations, evaluate=False)
                parse_expr(parts[1].strip(), transformations=transformations, evaluate=False)
        else:
            # Note: sympy.parse_expr("2 * * 4") doesn't actually raise an error for double operators in SymPy <= 1.12
            # it parses to 2*(*4) which is just 8. But some spaces between operators might need a manual check.
            if re.search(r'[\*\+\-/]\s+[\*\+\-/]', latex_str):
                raise ValueError("Multiple operators found in sequence")
            parse_expr(sympy_str, transformations=transformations, evaluate=False)
    except Exception as e:
        logger.error(f"Failed to parse mathematical expression '{latex_str}': {e}")
        raise ParseError(
            f"Unable to parse expression: {e}",
            {"expression": latex_str, "sympy_str": sympy_str},
        ) from e

    return sympy_str


def parse_expression(latex_str: str):
    """Safely parses a LaTeX string into a SymPy expression object."""
    sympy_str = parse_to_sympy_str(latex_str)
    transformations = standard_transformations + (implicit_multiplication_application,)

    try:
        expr = parse_expr(sympy_str, transformations=transformations, evaluate=False)
        return expr
    except Exception as e:
        logger.error(f"Failed to parse mathematical expression '{latex_str}': {e}")
        raise ParseError(
            f"Unable to parse expression: {e}",
            {"expression": latex_str, "sympy_str": sympy_str},
        ) from e


def classify_expression(latex_str: str) -> str:
    """Classifies the mathematical expression into a type.

    Possible types: 'arithmetic', 'equation', 'function', 'assignment', 'expression'
    """
    cleaned = clean_latex(latex_str)

    # Check for assignment first, e.g., 'a = 5' or 'x_1 = 10'
    # Assignments are equations where LHS is a single variable name
    if "=" in cleaned:
        parts = cleaned.split("=")
        if len(parts) == 2:
            lhs = parts[0].strip()
            # If LHS is a simple variable (e.g., 'a' or 'y')
            if re.match(r"^[a-zA-Z][a-zA-Z0-9_]*$", lhs):
                if lhs == "y" or lhs == "f":
                    # Common function declaration, e.g., 'y = x^2'
                    return "function"
                return "assignment"
            elif re.match(r"^[a-zA-Z][a-zA-Z0-9_]*\([a-zA-Z0-9_,\s]+\)$", lhs):
                # e.g., f(x) = x^2
                return "function"
            return "equation"

    # Check if expression contains only numbers and standard arithmetic operations
    # No variables
    has_letters = re.search(r"[a-zA-Z]", cleaned)
    if not has_letters:
        return "arithmetic"

    # Standard function features (e.g. contains variables like x, y)
    if any(func in cleaned for func in ["sin", "cos", "tan", "log", "sqrt", "exp"]):
        return "function" if "x" in cleaned else "expression"

    return "expression"


def analyze_expression(latex_str: str) -> dict:
    """Analyzes a LaTeX expression to extract variables, defined variable, and dependencies."""
    cleaned = clean_latex(latex_str)
    sympy_str = parse_to_sympy_str(latex_str)
    expr_type = classify_expression(latex_str)
    
    # Parse to SymPy expression to extract symbols
    expr = parse_expression(latex_str)
    
    # Extract variables (free symbols as strings)
    variables = sorted(list(set(str(s) for s in expr.free_symbols)))
    
    defined_variable = None
    dependencies = list(variables)
    
    if expr_type == "assignment" and "=" in cleaned:
        parts = cleaned.split("=")
        if len(parts) == 2:
            lhs = parts[0].strip()
            if re.match(r"^[a-zA-Z][a-zA-Z0-9_]*$", lhs):
                defined_variable = lhs
                try:
                    rhs_expr = parse_expression(parts[1].strip())
                    dependencies = sorted(list(set(str(s) for s in rhs_expr.free_symbols)))
                except Exception:
                    dependencies = []
    elif expr_type == "function" and "=" in cleaned:
        parts = cleaned.split("=")
        if len(parts) == 2:
            lhs = parts[0].strip()
            if re.match(r"^([a-zA-Z][a-zA-Z0-9_]*)\(([a-zA-Z0-9_,\s]+)\)$", lhs):
                match = re.match(r"^([a-zA-Z][a-zA-Z0-9_]*)\(([a-zA-Z0-9_,\s]+)\)$", lhs)
                defined_variable = match.group(1)
                params = {p.strip() for p in match.group(2).split(",")}
                try:
                    rhs_expr = parse_expression(parts[1].strip())
                    dependencies = sorted(list(set(str(s) for s in rhs_expr.free_symbols if str(s) not in params)))
                except Exception:
                    dependencies = []
            elif re.match(r"^[a-zA-Z][a-zA-Z0-9_]*$", lhs):
                defined_variable = lhs
                try:
                    rhs_expr = parse_expression(parts[1].strip())
                    dependencies = sorted(list(set(str(s) for s in rhs_expr.free_symbols)))
                except Exception:
                    dependencies = []
                    
    return {
        "sympy_str": sympy_str,
        "type": expr_type,
        "variables": variables,
        "defined_variable": defined_variable,
        "dependencies": dependencies
    }

