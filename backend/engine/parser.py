import re
import logging
from sympy.parsing.sympy_parser import (
    parse_expr,
    standard_transformations,
    implicit_multiplication_application,
)
from core.errors import ParseError

logger = logging.getLogger(__name__)

def clean_latex(latex_str: str) -> str:
    """Preprocesses LaTeX strings into SymPy-compatible syntax."""
    if not latex_str:
        return ""

    # Remove LaTeX spacing commands
    cleaned = re.sub(r'\\,|\\;|\\!|\\quad|\\qquad', '', latex_str)

    # Convert LaTeX brackets/parentheses
    cleaned = cleaned.replace(r'\left(', '(').replace(r'\right)', ')')
    cleaned = cleaned.replace(r'\left[', '[').replace(r'\right]', ']')
    cleaned = cleaned.replace(r'\left\{', '{').replace(r'\right\}', '}')

    # Convert standard trig and mathematical functions
    cleaned = re.sub(r'\\(sin|cos|tan|cot|sec|csc|log|ln|exp|sqrt)', r'\1', cleaned)

    # Convert fractions: \frac{a}{b} -> ((a)/(b))
    # Using a loop to handle nested fractions
    while r'\frac' in cleaned:
        match = re.search(r'\\frac\s*\{([^}]*)\}\s*\{([^}]*)\}', cleaned)
        if not match:
            break
        cleaned = cleaned.replace(match.group(0), f"(({match.group(1)})/({match.group(2)}))")

    # Convert exponents: ^ -> **
    cleaned = cleaned.replace('^', '**')

    # Convert variable notations if any, e.g., \pi -> pi
    cleaned = cleaned.replace(r'\pi', 'pi')
    cleaned = cleaned.replace(r'\theta', 'theta')

    # Strip remaining backslashes
    cleaned = cleaned.replace('\\', '')

    return cleaned.strip()

def parse_to_sympy_str(latex_str: str) -> str:
    """Converts a LaTeX expression string to a SymPy-compatible string.

    Returns:
        A SymPy parsable expression string (e.g. 'Eq(2*x + 4, 8)' or '2*x + 4').
    """
    cleaned = clean_latex(latex_str)
    
    if "=" in cleaned:
        parts = cleaned.split("=")
        if len(parts) == 2:
            return f"Eq({parts[0].strip()}, {parts[1].strip()})"
        else:
            raise ParseError(
                "Multiple '=' characters found in equation",
                {"expression": latex_str}
            )

    return cleaned

def parse_expression(latex_str: str):
    """Safely parses a LaTeX string into a SymPy expression object."""
    sympy_str = parse_to_sympy_str(latex_str)
    transformations = standard_transformations + (implicit_multiplication_application,)
    
    try:
        # Evaluate with transformations for implicit multiplication like 2x -> 2*x
        expr = parse_expr(sympy_str, transformations=transformations, evaluate=False)
        return expr
    except Exception as e:
        logger.error(f"Failed to parse mathematical expression '{latex_str}': {e}")
        raise ParseError(
            f"Unable to parse expression: {e}",
            {"expression": latex_str, "sympy_str": sympy_str}
        )

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
            rhs = parts[1].strip()
            # If LHS is a simple variable (e.g., 'a' or 'y')
            if re.match(r'^[a-zA-Z][a-zA-Z0-9_]*$', lhs):
                if lhs == 'y' or lhs == 'f':
                    # Common function declaration, e.g., 'y = x^2'
                    return "function"
                return "assignment"
            return "equation"
            
    # Check if expression contains only numbers and standard arithmetic operations
    # No variables
    has_letters = re.search(r'[a-zA-Z]', cleaned)
    if not has_letters:
        return "arithmetic"
        
    # Standard function features (e.g. contains variables like x, y)
    if any(func in cleaned for func in ["sin", "cos", "tan", "log", "sqrt"]):
        return "function" if "x" in cleaned else "expression"
        
    return "expression"
