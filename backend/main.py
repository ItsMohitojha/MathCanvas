import uvicorn
from fastapi import FastAPI
from api.routes import health, parse, solve, graph
from core.config import settings
from core.logging import setup_logging

# Set up system-wide logger configuration
setup_logging()

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="Local mathematical computation service wrapping SymPy and Plotly."
)

# Register route handlers
app.include_router(health.router)
app.include_router(parse.router, prefix=settings.API_V1_STR)
app.include_router(solve.router, prefix=settings.API_V1_STR)
app.include_router(graph.router, prefix=settings.API_V1_STR)

if __name__ == "__main__":
    uvicorn.run("main:app", host=settings.HOST, port=settings.PORT, reload=True)
