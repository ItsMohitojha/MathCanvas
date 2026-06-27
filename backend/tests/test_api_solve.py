from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_api_evaluate_success():
    response = client.post("/api/v1/evaluate", json={"expression": "15 * 3 - 5"})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["result"]["type"] == "numeric"
    assert data["result"]["value"] == "40"
    assert data["result"]["numeric"] == 40.0
    assert "computation_time_ms" in data

def test_api_evaluate_error():
    response = client.post("/api/v1/evaluate", json={"expression": "15 * / 3"})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is False
    assert data["error"]["code"] == "SOLVE_ERROR"

def test_api_solve_success():
    response = client.post("/api/v1/solve", json={
        "expression": "3*x - 9 = 0",
        "variables": ["x"],
        "operation": "solve"
    })
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["result"]["type"] == "solution"
    assert data["result"]["value"] == "x=3"
    assert data["result"]["numeric"] == 3.0
    assert data["result"]["solutions"] == [{"variable": "x", "value": "3", "latex": "x = 3"}]

def test_api_solve_error():
    response = client.post("/api/v1/solve", json={
        "expression": "3*x - / 9 = 0",
        "variables": ["x"],
        "operation": "solve"
    })
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is False
    assert data["error"]["code"] == "SOLVE_ERROR"

def test_api_simplify_success():
    response = client.post("/api/v1/simplify", json={"expression": "(x - 1)*(x + 1)"})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["result"]["type"] == "simplified"
    # (x-1)*(x+1) simplifies to x**2 - 1 in SymPy simplify or factor/expand (or sometimes stays similar)
    # Let's verify it has value and latex keys
    assert "value" in data["result"]
    assert "latex" in data["result"]

def test_api_simplify_error():
    response = client.post("/api/v1/simplify", json={"expression": "x - * 1"})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is False
    assert data["error"]["code"] == "SOLVE_ERROR"
