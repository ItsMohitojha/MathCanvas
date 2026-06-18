import time
from fastapi import APIRouter
from api.models.requests import ParseRequest
from api.models.responses import ResponseEnvelope, ErrorDetail
from engine.parser import parse_to_sympy_str, classify_expression
from core.errors import ParseError

router = APIRouter()

@router.post("/parse", response_model=ResponseEnvelope)
def parse_expression_route(request: ParseRequest) -> ResponseEnvelope:
    """Parses raw LaTeX math strings into SymPy-compatible structures."""
    start_time = time.perf_counter()
    try:
        sympy_str = parse_to_sympy_str(request.expression)
        expr_type = classify_expression(request.expression)
        duration_ms = int((time.perf_counter() - start_time) * 1000)
        
        return ResponseEnvelope(
            success=True,
            result={
                "sympy_str": sympy_str,
                "type": expr_type
            },
            computation_time_ms=duration_ms
        )
    except ParseError as e:
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
