import pytest
import time
from sympy import symbols
from core.errors import SolveError, TimeoutError
from engine.solver import MathSolver, MathResult

def test_evaluate_arithmetic_success():
    solver = MathSolver()
    res = solver.evaluate_arithmetic("2 + 3 * 4")
    assert isinstance(res, MathResult)
    assert res.result_type == "numeric"
    assert res.value == "14"
    assert res.latex_str == "14"
    assert res.numeric == 14.0

def test_evaluate_arithmetic_error():
    solver = MathSolver()
    with pytest.raises(SolveError):
        solver.evaluate_arithmetic("2 + * 4")

def test_solve_equation_single_var():
    solver = MathSolver()
    res = solver.solve_equation("2*x + 4 = 8", ["x"])
    assert res.result_type == "solution"
    assert res.value == "x=2"
    assert res.numeric == 2.0
    assert res.solutions == [{"variable": "x", "value": "2", "latex": "x = 2"}]

def test_solve_equation_multi_var():
    solver = MathSolver()
    res = solver.solve_equation("x + y = 5", ["x", "y"])
    assert res.result_type == "solution"
    assert "x=" in res.value
    assert "y=" in res.value
    assert len(res.solutions) == 2

def test_solve_equation_error():
    solver = MathSolver()
    with pytest.raises(SolveError):
        # Unsolvable or invalid syntax
        solver.solve_equation("x + * 5 = 10", ["x"])

def test_simplify_expression_success():
    solver = MathSolver()
    res = solver.simplify_expression("(x**2 - 1)/(x - 1)")
    assert res.result_type == "simplified"
    assert res.value == "x + 1"
    assert "x + 1" in res.latex_str

def test_solver_caching():
    solver = MathSolver()
    # First call (evaluates)
    res1 = solver.evaluate_arithmetic("100 + 200")
    # Second call (must hit cache)
    res2 = solver.evaluate_arithmetic("100 + 200")
    assert res1 is res2
    assert ("evaluate", "100 + 200", None) in solver._cache

def test_solver_timeout():
    # Set a very low timeout and mock a slow function
    solver = MathSolver(timeout_seconds=1)
    
    def slow_func():
        time.sleep(2)
        return MathResult("numeric", "0", "0")
        
    with pytest.raises(TimeoutError):
        solver.run_with_timeout(slow_func)
