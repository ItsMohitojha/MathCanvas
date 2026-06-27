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

def test_evaluate_arithmetic_with_symbol_table():
    solver = MathSolver()
    res = solver.evaluate_arithmetic("a + 1", {"a": "2"})
    assert res.value == "3"

def test_solve_equation_with_symbol_table():
    solver = MathSolver()
    res = solver.solve_equation("x + a = 5", ["x"], {"a": "2"})
    assert res.value == "x=3"

def test_solve_equation_cache_hit():
    solver = MathSolver()
    res1 = solver.solve_equation("x = 2", ["x"])
    res2 = solver.solve_equation("x = 2", ["x"])
    assert res1 is res2

def test_simplify_expression_cache_hit_and_symbol_table():
    solver = MathSolver()
    res1 = solver.simplify_expression("x + a", {"a": "y"})
    res2 = solver.simplify_expression("x + a", {"a": "y"})
    assert res1 is res2
    assert res1.value == "x + y"

def test_solve_equation_no_solutions():
    solver = MathSolver()
    # No solution Eq(1, 0)
    with pytest.raises(SolveError):
        solver.solve_equation("1 = 0", ["x"])

def test_solve_equation_symbolic_solution():
    solver = MathSolver()
    # Solution is symbolic (-y), float conversion raises error which is ignored
    res = solver.solve_equation("x + y = 0", ["x"])
    assert res.value == "x=-y"
    assert res.numeric is None

def test_solve_equation_dict_and_fallback_mock(mocker):
    solver = MathSolver()
    # Mock solve to return dict and then a fallback non-list/non-dict
    mocker.patch("engine.solver.solve", return_value={"x": 5})
    res1 = solver.solve_equation("x = 5", ["x"])
    assert res1.value == "x=5"

    solver._cache.clear()
    mocker.patch("engine.solver.solve", return_value="fallback_val")
    res2 = solver.solve_equation("x = 5", ["x"])
    assert res2.value == "x=fallback_val"

def test_run_with_timeout_generic_error():
    solver = MathSolver()
    
    def fail_func():
        raise ValueError("Generic computation error")
        
    with pytest.raises(SolveError, match="Calculation error: Generic computation error"):
        solver.run_with_timeout(fail_func)

