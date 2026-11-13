import os
import time
from flask import Flask, Response, jsonify

app = Flask(__name__)

START_TIME = time.time()
REQUEST_COUNT = 0
HEALTH_CHECK_COUNT = 0


@app.before_request
def track_requests():
    global REQUEST_COUNT
    REQUEST_COUNT += 1


@app.route("/", methods=["GET"])
def index():
    return jsonify(
        {
            "service": "order-status-api",
            "version": os.getenv("APP_VERSION", "1.0.0"),
            "environment": os.getenv("APP_ENV", "production"),
            "status": "running",
        }
    ), 200


@app.route("/health", methods=["GET"])
def health():
    global HEALTH_CHECK_COUNT
    HEALTH_CHECK_COUNT += 1
    return jsonify({"status": "healthy"}), 200


@app.route("/ready", methods=["GET"])
def ready():
    return jsonify({"status": "ready"}), 200


@app.route("/metrics", methods=["GET"])
def metrics():
    uptime = round(time.time() - START_TIME, 2)
    payload = "\n".join(
        [
            "# HELP app_requests_total Total HTTP requests handled by the service",
            "# TYPE app_requests_total counter",
            f"app_requests_total {REQUEST_COUNT}",
            "# HELP app_health_checks_total Total health check requests",
            "# TYPE app_health_checks_total counter",
            f"app_health_checks_total {HEALTH_CHECK_COUNT}",
            "# HELP app_uptime_seconds Service uptime in seconds",
            "# TYPE app_uptime_seconds gauge",
            f"app_uptime_seconds {uptime}",
            "",
        ]
    )
    return Response(payload, mimetype="text/plain; version=0.0.4")


if __name__ == "__main__":
    port = int(os.getenv("PORT", "8080"))
    app.run(host="0.0.0.0", port=port)
