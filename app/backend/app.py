import json
import logging
import os
import time
import uuid

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
from starlette.responses import Response

from opentelemetry import trace
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor

LOG = logging.getLogger("mobile-platform")
logging.basicConfig(level=os.getenv("LOG_LEVEL", "INFO"), format="%(message)s")

REQUESTS = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["method", "route", "status"],
)

LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP request latency",
    ["method", "route"],
)

app = FastAPI(title="mobile-platform-api", version="1.0.0")
FastAPIInstrumentor.instrument_app(app)
tracer = trace.get_tracer("mobile-platform-api")


@app.middleware("http")
async def telemetry(request: Request, call_next):
    start = time.perf_counter()
    response = await call_next(request)
    elapsed = time.perf_counter() - start

    route = request.scope.get("route")
    route_name = getattr(route, "path", request.url.path)

    REQUESTS.labels(request.method, route_name, str(response.status_code)).inc()
    LATENCY.labels(request.method, route_name).observe(elapsed)

    payload = {
        "timestamp": time.time(),
        "request_id": request.headers.get("x-request-id", str(uuid.uuid4())),
        "method": request.method,
        "path": request.url.path,
        "status": response.status_code,
        "duration_ms": round(elapsed * 1000, 3),
    }

    LOG.info(json.dumps(payload))
    return response


@app.get("/healthz")
def healthz():
    return {"status": "ok"}


@app.get("/readyz")
def readyz():
    return {"status": "ready"}


@app.get("/v1/jobs")
def jobs():
    return {
        "items": [
            {
                "id": "job-1",
                "title": "DevOps Engineer",
                "location": "Hyderabad",
            }
        ]
    }


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)


@app.exception_handler(Exception)
async def unhandled_exception(request: Request, exc: Exception):
    LOG.exception("unhandled_exception")
    return JSONResponse(
        status_code=500,
        content={"error": "internal_server_error"},
    )
