import time
from fastapi import APIRouter

router = APIRouter()

START_TIME = time.time()

@router.get("/health")
def health_check() -> dict:
    """Readiness probe for the local backend server."""
    return {
        "status": "ready",
        "version": "1.0.0",
        "uptime_seconds": time.time() - START_TIME
    }
