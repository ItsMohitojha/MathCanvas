import os

class Settings:
    PROJECT_NAME: str = "MathCanvas Backend"
    API_V1_STR: str = "/api/v1"
    HOST: str = os.getenv("MATHCANVAS_HOST", "127.0.0.1")
    PORT: int = int(os.getenv("MATHCANVAS_PORT", 8400))
    TIMEOUT_SECONDS: int = 10

settings = Settings()
