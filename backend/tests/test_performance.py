import time
import pytest
from engine.solver import MathSolver
from engine.grapher import generate_graph_data

def test_sympy_evaluation_performance():
    solver = MathSolver()
    
    # 1. Arithmetic evaluation speed (100 runs)
    start_time = time.perf_counter()
    for _ in range(100):
        res = solver.evaluate_arithmetic("2 + 3 * 4 - 5 / 2")
        assert res.value == "11.5"
    duration = time.perf_counter() - start_time
    # Should easily complete in < 0.5 seconds
    assert duration < 0.5, f"Arithmetic evaluation took too long: {duration:.4f}s"
    print(f"\n[BENCHMARK] 100 arithmetic evaluations: {duration:.4f}s ({duration/100*1000:.4f} ms/op)")

def test_sympy_equation_solving_performance():
    solver = MathSolver()
    
    # 2. Equation solving speed (50 runs)
    start_time = time.perf_counter()
    for _ in range(50):
        # Disable cache to get actual solving time
        solver._cache.clear()
        res = solver.solve_equation("x**2 - 5*x + 6 = 0", ["x"])
        assert len(res.solutions) == 2
    duration = time.perf_counter() - start_time
    # Should easily complete in < 1.0 second
    assert duration < 1.0, f"Equation solving took too long: {duration:.4f}s"
    print(f"\n[BENCHMARK] 50 equation solvings: {duration:.4f}s ({duration/50*1000:.4f} ms/op)")

def test_graph_generation_performance():
    # 3. Coordinate calculation (50 runs of 500 points)
    start_time = time.perf_counter()
    for _ in range(50):
        res = generate_graph_data("sin(x) * cos(x)", num_points=500)
        assert len(res["x"]) == 500
    duration = time.perf_counter() - start_time
    # Should easily complete in < 1.0 second
    assert duration < 1.0, f"Graph generation took too long: {duration:.4f}s"
    print(f"\n[BENCHMARK] 50 graph generations (500 pts): {duration:.4f}s ({duration/50*1000:.4f} ms/op)")
