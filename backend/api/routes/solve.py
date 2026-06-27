import time
from fastapi import APIRouter
from api.models.requests import SolveRequest, EvaluateRequest, SimplifyRequest
from api.models.responses import ResponseEnvelope, ErrorDetail
from engine.solver import MathSolver
from core.errors import MathCanvasError

router = APIRouter()
solver = MathSolver()

@router.post("/solve", response_model=ResponseEnvelope)
def solve_route(request: SolveRequest) -> ResponseEnvelope:
    """Solves an algebraic equation for the given variables."""
    start_time = time.perf_counter()
    try:
        res = solver.run_with_timeout(solver.solve_equation, request.expression, request.variables, request.symbol_table)
        duration_ms = int((time.perf_counter() - start_time) * 1000)
        
        return ResponseEnvelope(
            success=True,
            result={
                "type": res.result_type,
                "value": res.value,
                "latex": res.latex_str,
                "numeric": res.numeric,
                "solutions": res.solutions
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

@router.post("/evaluate", response_model=ResponseEnvelope)
def evaluate_route(request: EvaluateRequest) -> ResponseEnvelope:
    """Evaluates an arithmetic expression and returns a numeric result."""
    start_time = time.perf_counter()
    try:
        res = solver.run_with_timeout(solver.evaluate_arithmetic, request.expression, request.symbol_table)
        duration_ms = int((time.perf_counter() - start_time) * 1000)
        
        return ResponseEnvelope(
            success=True,
            result={
                "type": res.result_type,
                "value": res.value,
                "latex": res.latex_str,
                "numeric": res.numeric
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

@router.post("/simplify", response_model=ResponseEnvelope)
def simplify_route(request: SimplifyRequest) -> ResponseEnvelope:
    """Simplifies a symbolic expression."""
    start_time = time.perf_counter()
    try:
        res = solver.run_with_timeout(solver.simplify_expression, request.expression, request.symbol_table)
        duration_ms = int((time.perf_counter() - start_time) * 1000)
        
        return ResponseEnvelope(
            success=True,
            result={
                "type": res.result_type,
                "value": res.value,
                "latex": res.latex_str,
                "numeric": res.numeric
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
