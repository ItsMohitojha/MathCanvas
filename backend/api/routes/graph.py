import time
from fastapi import APIRouter
from api.models.requests import GraphRequest
from api.models.responses import ResponseEnvelope, ErrorDetail
from engine.grapher import generate_graph_data, generate_graph_html
from core.errors import MathCanvasError

router = APIRouter()

@router.post("/graph", response_model=ResponseEnvelope)
def graph_route(request: GraphRequest) -> ResponseEnvelope:
    """Generates graph coordinate data or interactive HTML visualizations for functions."""
    start_time = time.perf_counter()
    try:
        data = None
        html = None
        image_base64 = None
        
        style_dict = request.style.model_dump() if request.style else {}
        
        if request.output_format == "data":
            data = generate_graph_data(
                request.expression,
                request.variable,
                request.x_range[0],
                request.x_range[1],
                request.num_points,
                style_dict
            )
        elif request.output_format == "html":
            html = generate_graph_html(
                request.expression,
                request.variable,
                request.x_range[0],
                request.x_range[1],
                request.num_points,
                style_dict
            )
        else:
            raise MathCanvasError("UNSUPPORTED_OPERATION", f"Unsupported output format: {request.output_format}")
            
        duration_ms = int((time.perf_counter() - start_time) * 1000)
        
        return ResponseEnvelope(
            success=True,
            result={
                "type": "graph",
                "data": data,
                "html": html,
                "image_base64": image_base64
            },
            computation_time_ms=duration_ms
        )
    except MathCanvasError as e:
        duration_ms = int((time.perf_counter() - start_time) * 1000)
        return ResponseEnvelope(
            success=False,
            error=ErrorDetail(code=e.code, message=e.message, details=e.details),
            computation_time_ms=duration_ms
        )
    except Exception as e:
        duration_ms = int((time.perf_counter() - start_time) * 1000)
        return ResponseEnvelope(
            success=False,
            error=ErrorDetail(code="INTERNAL_ERROR", message=str(e)),
            computation_time_ms=duration_ms
        )
