from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_parse_expression_success():
    response = client.post("/api/v1/parse", json={"expression": "2x + 4"})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["result"]["sympy_str"] == "2x + 4"
    assert data["result"]["type"] == "expression"
    assert "computation_time_ms" in data


def test_parse_equation_success():
    response = client.post("/api/v1/parse", json={"expression": "2x + 4 = 8"})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["result"]["sympy_str"] == "Eq(2x + 4, 8)"
    assert data["result"]["type"] == "equation"


def test_parse_multiple_equals_error():
    response = client.post("/api/v1/parse", json={"expression": "2x = 4 = 8"})
    assert response.status_code == 422
    data = response.json()
    assert data["success"] is False
    assert data["error"]["code"] == "PARSE_ERROR"
    assert "Multiple '=' characters" in data["error"]["message"]


def test_parse_invalid_syntax_error():
    response = client.post("/api/v1/parse", json={"expression": "2x * * 4"})
    assert response.status_code == 422
    data = response.json()
    assert data["success"] is False
    assert data["error"]["code"] == "PARSE_ERROR"


def test_parse_arithmetic():
    response = client.post("/api/v1/parse", json={"expression": r"\frac{1}{2} + 3"})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["result"]["sympy_str"] == "((1)/(2)) + 3"
    assert data["result"]["type"] == "arithmetic"


def test_parse_assignment():
    response = client.post("/api/v1/parse", json={"expression": "a = 5"})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["result"]["sympy_str"] == "Eq(a, 5)"
    assert data["result"]["type"] == "assignment"


def test_parse_function():
    response = client.post("/api/v1/parse", json={"expression": "f(x) = x^2"})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["result"]["sympy_str"] == "Eq(f(x), x**2)"
    assert data["result"]["type"] == "function"

def test_parse_internal_error(mocker):
    # Mock analyze_expression to raise a generic Exception
    mocker.patch("api.routes.parse.analyze_expression", side_effect=Exception("Unexpected DB error"))
    response = client.post("/api/v1/parse", json={"expression": "2x + 4"})
    assert response.status_code == 500
    data = response.json()
    assert data["success"] is False
    assert data["error"]["code"] == "INTERNAL_ERROR"
    assert "Unexpected DB error" in data["error"]["message"]
