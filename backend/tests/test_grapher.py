import time
import math
import pytest
from engine.grapher import evaluate_function, generate_graph_data, generate_graph_html
from core.errors import SolveError


class TestEvaluateFunction:
    """Unit tests for the evaluate_function helper."""

    def test_basic_parabola(self):
        """x**2 should produce y values matching x squared."""
        x_vals, y_vals = evaluate_function("x**2", "x", -5.0, 5.0, 11)
        assert len(x_vals) == 11
        assert len(y_vals) == 11
        # Check a known point: x=0 -> y=0
        mid = len(x_vals) // 2
        assert abs(x_vals[mid]) < 1e-9
        assert abs(y_vals[mid]) < 1e-9
        # Check endpoints: x=-5 -> y=25, x=5 -> y=25
        assert abs(y_vals[0] - 25.0) < 1e-6
        assert abs(y_vals[-1] - 25.0) < 1e-6

    def test_linear_function(self):
        """2*x + 1 should produce a straight line."""
        x_vals, y_vals = evaluate_function("2*x + 1", "x", -3.0, 3.0, 7)
        assert len(x_vals) == 7
        for x, y in zip(x_vals, y_vals):
            assert y is not None
            assert abs(y - (2 * x + 1)) < 1e-6

    def test_trigonometric_sine(self):
        """sin(x) at x=0 should be 0, at x=pi/2 should be 1."""
        x_vals, y_vals = evaluate_function("sin(x)", "x", 0.0, math.pi, 100)
        assert len(x_vals) == 100
        # x=0 -> y=0
        assert abs(y_vals[0]) < 1e-6
        # x=pi -> y≈0
        assert abs(y_vals[-1]) < 1e-6

    def test_expression_with_equals_stripping(self):
        """y = x**2 should strip the 'y =' and evaluate x**2."""
        x_vals, y_vals = evaluate_function("y = x**2", "x", -2.0, 2.0, 5)
        assert len(x_vals) == 5
        assert abs(y_vals[0] - 4.0) < 1e-6
        assert abs(y_vals[-1] - 4.0) < 1e-6

    def test_invalid_expression_raises(self):
        """An unparseable expression should raise SolveError."""
        with pytest.raises(SolveError):
            evaluate_function("@#$%^&", "x", -1.0, 1.0, 10)

    def test_infinity_becomes_none(self):
        """Values exceeding 1e10 should be replaced with None."""
        # 1/x has a discontinuity at x=0 which produces very large values
        x_vals, y_vals = evaluate_function("1/x", "x", -0.001, 0.001, 3)
        # The middle point x≈0 will produce inf or huge value -> None
        assert None in y_vals or any(v is None for v in y_vals)

    def test_custom_variable_name(self):
        """Should work with variable names other than x."""
        x_vals, y_vals = evaluate_function("t**3", "t", 0.0, 2.0, 3)
        assert len(x_vals) == 3
        assert abs(y_vals[0] - 0.0) < 1e-6  # t=0
        assert abs(y_vals[-1] - 8.0) < 1e-6  # t=2

    def test_data_point_count(self):
        """Output should have exactly num_points data points."""
        x_vals, y_vals = evaluate_function("x", "x", 0.0, 10.0, 250)
        assert len(x_vals) == 250
        assert len(y_vals) == 250


class TestGenerateGraphData:
    """Unit tests for generate_graph_data."""

    def test_returns_required_keys(self):
        """Response must contain x, y, x_label, y_label, title, color."""
        result = generate_graph_data("x**2")
        assert "x" in result
        assert "y" in result
        assert "x_label" in result
        assert "y_label" in result
        assert "title" in result
        assert "color" in result

    def test_default_500_points(self):
        """Default num_points should produce 500 data points."""
        result = generate_graph_data("x")
        assert len(result["x"]) == 500
        assert len(result["y"]) == 500

    def test_custom_range_and_points(self):
        """Custom x_min, x_max, and num_points should be respected."""
        result = generate_graph_data("x", x_min=0.0, x_max=1.0, num_points=10)
        assert len(result["x"]) == 10
        assert result["x"][0] == 0.0
        assert abs(result["x"][-1] - 1.0) < 1e-9

    def test_custom_style_title(self):
        """Custom style title should be used."""
        result = generate_graph_data("x**2", style={"title": "My Chart"})
        assert result["title"] == "My Chart"

    def test_custom_style_color(self):
        """Custom style color should be used."""
        result = generate_graph_data("x", style={"color": "#ff0000"})
        assert result["color"] == "#ff0000"

    def test_default_title_format(self):
        """Default title should be 'y = <expression>'."""
        result = generate_graph_data("sin(x)")
        assert result["title"] == "y = sin(x)"

    def test_default_color(self):
        """Default color should be indigo (#6366f1)."""
        result = generate_graph_data("x")
        assert result["color"] == "#6366f1"


class TestGenerateGraphHtml:
    """Unit tests for generate_graph_html."""

    def test_returns_html_string(self):
        """Should return an HTML string (may be fallback if plotly missing)."""
        result = generate_graph_html("x**2")
        assert isinstance(result, str)
        assert "<" in result  # Contains HTML tags


class TestPerformance:
    """Performance tests for graph generation."""

    def test_graph_generation_under_3_seconds(self):
        """Generating 500-point graph should complete in < 3 seconds."""
        start = time.perf_counter()
        generate_graph_data("x**3 - 3*x**2 + 2*x", num_points=500)
        elapsed = time.perf_counter() - start
        assert elapsed < 3.0, f"Graph generation took {elapsed:.2f}s, expected < 3s"

    def test_trig_graph_under_3_seconds(self):
        """Trig function graph should also be fast."""
        start = time.perf_counter()
        generate_graph_data("sin(x) * cos(x)", num_points=500)
        elapsed = time.perf_counter() - start
        assert elapsed < 3.0, f"Graph generation took {elapsed:.2f}s, expected < 3s"

def test_evaluate_function_large_values():
    # Points will be 2.0e10, which is > 1e10 -> returns None (line 53)
    x_vals, y_vals = evaluate_function("x", "x", 2e10, 3e10, 3)
    assert all(y is None for y in y_vals)

def test_generate_graph_html_import_error(monkeypatch):
    import sys
    # Force ImportError on import plotly.graph_objects
    monkeypatch.setitem(sys.modules, "plotly.graph_objects", None)
    result = generate_graph_html("x**2")
    assert "Plotly graph not available: Plotly module missing" in result

def test_generate_graph_html_exception(mocker):
    # Force exception inside plotly figure creation
    mocker.patch("plotly.graph_objects.Figure", side_effect=Exception("Mock plotly error"))
    with pytest.raises(SolveError, match="Cannot generate graph HTML"):
        generate_graph_html("x**2")

