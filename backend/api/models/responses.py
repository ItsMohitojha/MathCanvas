from typing import Any, Dict, Optional
from pydantic import BaseModel

class ErrorDetail(BaseModel):
    code: str
    message: str
    details: Dict[str, Any] = {}

class ResponseEnvelope(BaseModel):
    success: bool
    result: Optional[Any] = None
    error: Optional[ErrorDetail] = None
    computation_time_ms: int
