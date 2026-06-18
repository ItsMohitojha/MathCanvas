import logging
from typing import Any, Dict, List, Tuple, Optional
import sympy as sp
from sympy.abc import _clash
from core.errors import SolveError

logger = logging.getLogger(__name__)

def evaluate_function(
    expression_str: str,
    variable_name: str,
    x_min: float,
    x_max: float,
    num_points: int
) -> Tuple[List[float], List[float]]:
    """Evaluates a function string over a range of points.

    Returns:
        A tuple of (x_values, y_values).
    """
    try:
        # Preprocess expression (strip 'y =' or similar)
        expr_str = expression_str
        if "=" in expression_str:
            parts = expression_str.split("=")
            if len(parts) == 2:
                # If LHS is a variable or function syntax, use RHS
                expr_str = parts[1].strip()
        
        # Sympify the expression
        # _clash dictionary prevents name collisions (e.g. S, C, O, I as symbols instead of sympy objects)
        var_symbol = sp.Symbol(variable_name)
        expr = sp.parse_expr(expr_str, local_dict={variable_name: var_symbol})
        
        # Generate x points
        x_step = (x_max - x_min) / (num_points - 1)
        x_values = [x_min + i * x_step for i in range(num_points)]
        
        # Use lambdify for fast evaluation
        # Falls back to math/mpmath if numpy isn't available
        try:
            f = sp.lambdify(var_symbol, expr, modules=["numpy", "math"])
        except Exception:
            f = sp.lambdify(var_symbol, expr, modules=["math"])
            
        y_values = []
        for x in x_values:
            try:
                y = float(f(x))
                # Handle infinity or complex numbers
                if abs(y) > 1e10 or sp.isnan(y):
                    y_values.append(None)
                else:
                    y_values.append(y)
            except Exception:
                y_values.append(None)
                
        return x_values, y_values
    except Exception as e:
        logger.error(f"Failed to evaluate function '{expression_str}' for graphing: {e}")
        raise SolveError(f"Cannot evaluate function for graphing: {e}", {"expression": expression_str})

def generate_graph_data(
    expression_str: str,
    variable_name: str = "x",
    x_min: float = -10.0,
    x_max: float = 10.0,
    num_points: int = 500,
    style: Optional[Dict[str, Any]] = None
) -> Dict[str, Any]:
    """Generates standard JSON-serializable graph coordinates and metadata."""
    style = style or {}
    title = style.get("title", f"y = {expression_str}")
    color = style.get("color", "#6366f1")
    
    x_vals, y_vals = evaluate_function(expression_str, variable_name, x_min, x_max, num_points)
    
    # Filter out None values for JSON serialization (replace with null)
    # or keep them as None since Pydantic/JSON converts python None to null
    return {
        "x": x_vals,
        "y": y_vals,
        "x_label": variable_name,
        "y_label": "y",
        "title": title,
        "color": color
    }

def generate_graph_html(
    expression_str: str,
    variable_name: str = "x",
    x_min: float = -10.0,
    x_max: float = 10.0,
    num_points: int = 500,
    style: Optional[Dict[str, Any]] = None
) -> str:
    """Generates an interactive Plotly HTML chart as a string."""
    try:
        import plotly.graph_objects as go
        
        graph_data = generate_graph_data(expression_str, variable_name, x_min, x_max, num_points, style)
        
        fig = go.Figure()
        fig.add_trace(
            go.Scatter(
                x=graph_data["x"],
                y=graph_data["y"],
                mode="lines",
                name=graph_data["title"],
                line=dict(color=graph_data["color"], width=3)
            )
        )
        
        # Set layout
        show_grid = style.get("show_grid", True) if style else True
        fig.update_layout(
            title=graph_data["title"],
            xaxis_title=graph_data["x_label"],
            yaxis_title=graph_data["y_label"],
            xaxis=dict(showgrid=show_grid, zeroline=True),
            yaxis=dict(showgrid=show_grid, zeroline=True),
            template="plotly_white",
            margin=dict(l=40, r=40, t=40, b=40)
        )
        
        return fig.to_html(full_html=False, include_plotlyjs="cdn")
    except ImportError:
        logger.warning("Plotly is not installed. Returning a simplified HTML fallback.")
        return f"<html><body><h3>Plotly graph not available: Plotly module missing</h3></body></html>"
    except Exception as e:
        logger.error(f"Failed to generate Plotly HTML for '{expression_str}': {e}")
        raise SolveError(f"Cannot generate graph HTML: {e}", {"expression": expression_str})
