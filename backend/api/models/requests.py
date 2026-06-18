from typing import List, Optional
from pydantic import BaseModel, Field

class ParseRequest(BaseModel):
    expression: str = Field(..., description="Raw LaTeX expression string to parse")

class SolveRequest(BaseModel):
    expression: str = Field(..., description="SymPy-compatible string to solve")
    variables: List[str] = Field(default_factory=lambda: ["x"], description="List of variables to solve for")
    operation: str = Field(default="solve", description="Operation to perform: solve, expand, factor")

class EvaluateRequest(BaseModel):
    expression: str = Field(..., description="Arithmetic expression to evaluate")

class SimplifyRequest(BaseModel):
    expression: str = Field(..., description="Symbolic expression to simplify")

class GraphStyle(BaseModel):
    title: Optional[str] = None
    color: str = "#6366f1"
    show_grid: bool = True
    show_axes: bool = True

class GraphRequest(BaseModel):
    expression: str = Field(..., description="Expression to generate graph for")
    variable: str = Field(default="x", description="Independent variable name")
    x_range: List[float] = Field(default=[-10.0, 10.0], description="X axis minimum and maximum")
    num_points: int = Field(default=500, description="Number of data points to generate")
    output_format: str = Field(default="data", description="Output format: data, html, image")
    style: Optional[GraphStyle] = Field(default_factory=GraphStyle, description="Graph design settings")
