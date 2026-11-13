import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from server import app


def test_index_returns_service_metadata():
    client = app.test_client()
    resp = client.get("/")
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["service"] == "order-status-api"
    assert data["status"] == "running"


def test_health_and_ready_endpoints():
    client = app.test_client()
    assert client.get("/health").status_code == 200
    assert client.get("/ready").status_code == 200


def test_metrics_exposition_format():
    client = app.test_client()
    resp = client.get("/metrics")
    assert resp.status_code == 200
    body = resp.data.decode("utf-8")
    assert "app_requests_total" in body
    assert "app_uptime_seconds" in body
