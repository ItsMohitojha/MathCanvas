from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


class TestGraphDataFormat:
    """Tests for POST /api/v1/graph with data output format."""

    def test_graph_data_success(self):
        """Basic graph data generation should succeed."""
        response = client.post("/api/v1/graph", json={
            "expression": "x**2",
            "output_format": "data",
        })
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is True
        assert data["result"]["type"] == "graph"
        assert data["result"]["data"] is not None
        assert "x" in data["result"]["data"]
        assert "y" in data["result"]["data"]
        assert len(data["result"]["data"]["x"]) == 500  # default

    def test_graph_data_custom_range(self):
        """Custom x_range should be respected."""
        response = client.post("/api/v1/graph", json={
            "expression": "x",
            "x_range": [0.0, 5.0],
            "num_points": 10,
            "output_format": "data",
        })
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is True
        graph = data["result"]["data"]
        assert len(graph["x"]) == 10
        assert abs(graph["x"][0] - 0.0) < 1e-9
        assert abs(graph["x"][-1] - 5.0) < 1e-9

    def test_graph_data_with_style(self):
        """Custom style options should propagate to response."""
        response = client.post("/api/v1/graph", json={
            "expression": "sin(x)",
            "output_format": "data",
            "style": {
                "title": "Sine Wave",
                "color": "#ff0000",
            },
        })
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is True
        assert data["result"]["data"]["title"] == "Sine Wave"
        assert data["result"]["data"]["color"] == "#ff0000"

    def test_graph_data_custom_variable(self):
        """Custom variable name should work."""
        response = client.post("/api/v1/graph", json={
            "expression": "t**2",
            "variable": "t",
            "output_format": "data",
            "num_points": 5,
        })
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is True
        assert data["result"]["data"]["x_label"] == "t"

    def test_graph_computation_time_present(self):
        """Response should include computation_time_ms."""
        response = client.post("/api/v1/graph", json={
            "expression": "x",
            "output_format": "data",
        })
        data = response.json()
        assert "computation_time_ms" in data
        assert isinstance(data["computation_time_ms"], int)
        assert data["computation_time_ms"] >= 0


class TestGraphHtmlFormat:
    """Tests for POST /api/v1/graph with html output format."""

    def test_graph_html_returns_string(self):
        """HTML output should return an HTML string in result."""
        response = client.post("/api/v1/graph", json={
            "expression": "x**2",
            "output_format": "html",
        })
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is True
        assert data["result"]["type"] == "graph"
        # HTML may be a string or None if plotly is missing, but it should be in result
        assert data["result"]["html"] is not None


class TestGraphErrorHandling:
    """Tests for error cases in graph API."""

    def test_unsupported_format_error(self):
        """Requesting an unsupported format should return an error."""
        response = client.post("/api/v1/graph", json={
            "expression": "x",
            "output_format": "pdf",
        })
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is False
        assert data["error"]["code"] == "UNSUPPORTED_OPERATION"

    def test_malformed_expression_error(self):
        """An invalid expression should return an error response."""
        response = client.post("/api/v1/graph", json={
            "expression": "@#$%^&*",
            "output_format": "data",
        })
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is False
        assert data["error"] is not None

    def test_missing_expression_field(self):
        """Missing required 'expression' field should return 422."""
        response = client.post("/api/v1/graph", json={
            "output_format": "data",
        })
        assert response.status_code == 422

    def test_api_graph_generic_exception(self, mocker):
        mocker.patch("api.routes.graph.generate_graph_data", side_effect=Exception("Graph route unexpected exception"))
        response = client.post("/api/v1/graph", json={
            "expression": "x**2",
            "output_format": "data",
        })
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is False
        assert data["error"]["code"] == "INTERNAL_ERROR"
        assert "Graph route unexpected exception" in data["error"]["message"]

