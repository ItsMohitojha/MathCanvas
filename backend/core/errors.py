class MathCanvasError(Exception):
    """Base exception class for all MathCanvas backend errors."""
    def __init__(self, code: str, message: str, details: dict = None) -> None:
        super().__init__(message)
        self.code = code
        self.message = message
        self.details = details or {}

class ParseError(MathCanvasError):
    """Raised when an expression cannot be parsed into a mathematical representation."""
    def __init__(self, message: str, details: dict = None) -> None:
        super().__init__("PARSE_ERROR", message, details)

class SolveError(MathCanvasError):
    """Raised when an equation cannot be solved by SymPy."""
    def __init__(self, message: str, details: dict = None) -> None:
        super().__init__("SOLVE_ERROR", message, details)

class TimeoutError(MathCanvasError):
    """Raised when the execution of a math problem exceeds the time limit."""
    def __init__(self, message: str, details: dict = None) -> None:
        super().__init__("TIMEOUT", message, details)

class UnsupportedOperationError(MathCanvasError):
    """Raised when a client requests an operation that is not supported."""
    def __init__(self, message: str, details: dict = None) -> None:
        super().__init__("UNSUPPORTED_OPERATION", message, details)
