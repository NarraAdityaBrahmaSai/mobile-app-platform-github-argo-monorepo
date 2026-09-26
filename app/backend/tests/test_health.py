from fastapi.testclient import TestClient
from app import app

client = TestClient(app)


def test_health():
    response = client.get("/healthz")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_jobs():
    response = client.get("/v1/jobs")
    assert response.status_code == 200
    assert response.json()["items"][0]["title"] == "DevOps Engineer"
