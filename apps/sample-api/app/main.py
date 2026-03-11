from __future__ import annotations

import os
import random
import time
from contextlib import asynccontextmanager
from typing import Callable

from fastapi import FastAPI, HTTPException, Request, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Gauge, Histogram, generate_latest

APP_NAME = "sample-api"
APP_VERSION = os.getenv("APP_VERSION", "0.1.0")
FAILURE_RATE = float(os.getenv("FAILURE_RATE", "0"))

REQUEST_COUNTER = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["app", "method", "path", "status"],
)
REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP request latency",
    ["app", "method", "path"],
)
READINESS_GAUGE = Gauge("sample_api_ready", "Readiness indicator", ["app"])
INFO_GAUGE = Gauge("sample_api_info", "Build info", ["app", "version"])

@asynccontextmanager
async def lifespan(_app: FastAPI):
    READINESS_GAUGE.labels(APP_NAME).set(1)
    INFO_GAUGE.labels(APP_NAME, APP_VERSION).set(1)
    yield


app = FastAPI(title="sample-api", version=APP_VERSION, lifespan=lifespan)


@app.middleware("http")
async def metrics_middleware(request: Request, call_next: Callable) -> Response:
    path = request.url.path
    method = request.method
    start = time.perf_counter()

    try:
        response = await call_next(request)
        status = str(response.status_code)
        return response
    except Exception:
        status = "500"
        raise
    finally:
        elapsed = time.perf_counter() - start
        REQUEST_COUNTER.labels(APP_NAME, method, path, status).inc()
        REQUEST_LATENCY.labels(APP_NAME, method, path).observe(elapsed)


@app.get("/")
def home() -> dict:
    if FAILURE_RATE > 0 and random.random() < FAILURE_RATE:
        raise HTTPException(status_code=500, detail="transient failure simulation")
    return {"message": "hello from sample-api", "version": APP_VERSION}


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "version": APP_VERSION}


@app.get("/ready")
def ready() -> dict:
    return {"ready": True}


@app.get("/metrics")
def metrics() -> Response:
    return Response(content=generate_latest(), media_type=CONTENT_TYPE_LATEST)
