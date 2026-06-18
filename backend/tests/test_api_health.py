def test_health_check(client) -> None:
    """Verifies that the /health endpoint is available and responds correctly."""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "ready"
    assert "version" in data
    assert "uptime_seconds" in data
