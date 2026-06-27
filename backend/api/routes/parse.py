import time

from fastapi import APIRouter, Response, status

from api.models.requests import ParseRequest
from api.models.responses import ErrorDetail, ResponseEnvelope
from core.errors import ParseError
from engine.parser import analyze_expression

router = APIRouter()


@router.post("/parse", response_model=ResponseEnvelope)
def parse_expression_route(
    request: ParseRequest, response: Response
) -> ResponseEnvelope:
    """Parses raw LaTeX math strings into SymPy-compatible structures."""
    start_time = time.perf_counter()
    try:
        analysis = analyze_expression(request.expression)
        duration_ms = int((time.perf_counter() - start_time) * 1000)

        return ResponseEnvelope(
            success=True,
            result=analysis,
            computation_time_ms=duration_ms,
        )
    except ParseError as e:
        response.status_code = status.HTTP_422_UNPROCESSABLE_ENTITY
        duration_ms = int((time.perf_counter() - start_time) * 1000)
        return ResponseEnvelope(
            success=False,
            error=ErrorDetail(code=e.code, message=e.message, details=e.details),
            computation_time_ms=duration_ms,
        )
    except Exception as e:
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        duration_ms = int((time.perf_counter() - start_time) * 1000)
        return ResponseEnvelope(
            success=False,
            error=ErrorDetail(code="INTERNAL_ERROR", message=str(e)),
            computation_time_ms=duration_ms,
        )
