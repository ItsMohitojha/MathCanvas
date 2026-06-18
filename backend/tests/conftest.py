import pytest
from fastapi.testclient import TestClient
from main import app

@pytest.fixture(scope="module")
def client():
    """Returns a FastAPI TestClient instance for running API tests."""
    with TestClient(app) as c:
        yield c
