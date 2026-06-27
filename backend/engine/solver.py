import logging
from typing import Any, Dict, List, Optional, Union
import concurrent.futures
from sympy import (
    Eq,
    latex,
    solve,
    simplify,
    sympify,
    Symbol,
)
from core.errors import SolveError, TimeoutError
from engine.parser import parse_expression

logger = logging.getLogger(__name__)

class MathResult:
    def __init__(
        self,
        result_type: str,
        value: str,
        latex_str: str,
        numeric: Optional[float] = None,
        solutions: Optional[List[Dict[str, str]]] = None,
    ) -> None:
        self.result_type = result_type
        self.value = value
        self.latex_str = latex_str
        self.numeric = numeric
        self.solutions = solutions

class MathSolver:
    def __init__(self, timeout_seconds: int = 10) -> None:
        self.timeout_seconds = timeout_seconds
        self._cache = {}

    def evaluate_arithmetic(self, expression_str: str, symbol_table: Optional[Dict[str, str]] = None) -> MathResult:
        """Evaluates an arithmetic expression and returns a numeric result."""
        cache_key = ("evaluate", expression_str, tuple(sorted(symbol_table.items())) if symbol_table else None)
        if cache_key in self._cache:
            logger.info(f"Cache hit for evaluate_arithmetic: '{expression_str}'")
            return self._cache[cache_key]

        try:
            expr = sympify(expression_str)
            if symbol_table:
                subs_dict = {Symbol(k): sympify(v) for k, v in symbol_table.items()}
                expr = expr.subs(subs_dict)
            # Evaluate to float
            val = expr.evalf()
            numeric_val = float(val)
            # Check if it's integer-like
            if numeric_val.is_integer():
                numeric_val = int(numeric_val)
            
            res = MathResult(
                result_type="numeric",
                value=str(numeric_val),
                latex_str=latex(expr),
                numeric=float(numeric_val),
            )
            self._cache[cache_key] = res
            return res
        except Exception as e:
            logger.error(f"Arithmetic evaluation failed for '{expression_str}': {e}")
            raise SolveError(f"Cannot evaluate arithmetic: {e}", {"expression": expression_str})

    def solve_equation(self, expression_str: str, vars_to_solve: List[str], symbol_table: Optional[Dict[str, str]] = None) -> MathResult:
        """Solves an algebraic equation for specified variables."""
        cache_key = ("solve", expression_str, tuple(sorted(vars_to_solve)), tuple(sorted(symbol_table.items())) if symbol_table else None)
        if cache_key in self._cache:
            logger.info(f"Cache hit for solve_equation: '{expression_str}' (vars: {vars_to_solve})")
            return self._cache[cache_key]

        try:
            # Parse equation (e.g. Eq(2*x + 4, 8))
            expr = parse_expression(expression_str)
            if symbol_table:
                subs_dict = {Symbol(k): sympify(v) for k, v in symbol_table.items() if k not in vars_to_solve}
                expr = expr.subs(subs_dict)
            
            # Identify variables (Symbols)
            symbols_list = [Symbol(v) for v in vars_to_solve]
            
            # Solve using SymPy
            sols = solve(expr, symbols_list)
            
            solutions_list = []
            
            # Format solutions
            if isinstance(sols, list):
                for sol in sols:
                    if isinstance(sol, tuple):
                        # Multi-variable solution
                        for var_symbol, sol_val in zip(symbols_list, sol):
                            solutions_list.append({
                                "variable": str(var_symbol),
                                "value": str(sol_val),
                                "latex": f"{latex(var_symbol)} = {latex(sol_val)}"
                            })
                    else:
                        # Single variable solution
                        var_symbol = symbols_list[0]
                        solutions_list.append({
                            "variable": str(var_symbol),
                            "value": str(sol),
                            "latex": f"{latex(var_symbol)} = {latex(sol)}"
                        })
            elif isinstance(sols, dict):
                # Dictionary mapping symbols to values
                for symbol, val in sols.items():
                    solutions_list.append({
                        "variable": str(symbol),
                        "value": str(val),
                        "latex": f"{latex(symbol)} = {latex(val)}"
                    })
            else:
                # Fallback
                solutions_list.append({
                    "variable": vars_to_solve[0],
                    "value": str(sols),
                    "latex": f"{vars_to_solve[0]} = {latex(sols)}"
                })

            if not solutions_list:
                raise SolveError("No solutions found", {"expression": expression_str})
                
            # Aggregate LaTeX string
            combined_latex = ", ".join([sol["latex"] for sol in solutions_list])
            combined_value = ", ".join([f"{sol['variable']}={sol['value']}" for sol in solutions_list])

            # Compute first numeric value if simple
            numeric_val = None
            try:
                if len(solutions_list) == 1:
                    numeric_val = float(sympify(solutions_list[0]["value"]).evalf())
            except Exception:
                pass

            res = MathResult(
                result_type="solution",
                value=combined_value,
                latex_str=combined_latex,
                numeric=numeric_val,
                solutions=solutions_list,
            )
            self._cache[cache_key] = res
            return res
        except Exception as e:
            logger.error(f"Equation solving failed for '{expression_str}': {e}")
            raise SolveError(f"Cannot solve equation: {e}", {"expression": expression_str})

    def simplify_expression(self, expression_str: str, symbol_table: Optional[Dict[str, str]] = None) -> MathResult:
        """Simplifies a symbolic expression."""
        cache_key = ("simplify", expression_str, tuple(sorted(symbol_table.items())) if symbol_table else None)
        if cache_key in self._cache:
            logger.info(f"Cache hit for simplify_expression: '{expression_str}'")
            return self._cache[cache_key]

        try:
            expr = parse_expression(expression_str)
            if symbol_table:
                subs_dict = {Symbol(k): sympify(v) for k, v in symbol_table.items()}
                expr = expr.subs(subs_dict)
            simplified_expr = simplify(expr)
            
            res = MathResult(
                result_type="simplified",
                value=str(simplified_expr),
                latex_str=latex(simplified_expr),
            )
            self._cache[cache_key] = res
            return res
        except Exception as e:
            logger.error(f"Simplification failed for '{expression_str}': {e}")
            raise SolveError(f"Cannot simplify expression: {e}", {"expression": expression_str})

    def run_with_timeout(self, func, *args, **kwargs) -> MathResult:
        """Runs a solver function with a strict timeout limit."""
        with concurrent.futures.ThreadPoolExecutor(max_workers=1) as executor:
            future = executor.submit(func, *args, **kwargs)
            try:
                return future.result(timeout=self.timeout_seconds)
            except concurrent.futures.TimeoutError:
                logger.error("Mathematical computation timed out")
                raise TimeoutError("The computation timed out.", {"timeout": self.timeout_seconds})
            except Exception as e:
                if isinstance(e, SolveError) or isinstance(e, TimeoutError):
                    raise e
                raise SolveError(f"Calculation error: {e}")
