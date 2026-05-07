from flask import Flask
from prometheus_flask_exporter import PrometheusMetrics
from prometheus_client import Counter
import os
import socket

app = Flask(__name__)

# En rad – aktiverar automatisk mätning av ALLA HTTP-requests.
# Skapar /metrics-endpointet automatiskt.
metrics = PrometheusMetrics(app)

# En manuell räknare för startsidan – visar hur man mäter affärshändelser.
home_visits = Counter(
    "webapp_home_visits_total",
    "Totalt antal besök på startsidan"
)

@app.route("/")
def home():
    home_visits.inc()  # Öka räknaren med 1 vid varje besök

    hostname = socket.gethostname()
    version = os.environ.get("APP_VERSION", "1.0.0")
    environment = os.environ.get("ENVIRONMENT", "unknown")

    return f"""
    <html>
    <head><title>Labb 8 - Grafana</title></head>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 50px auto;">
        <h1>Labb 8 – Monitoring med Prometheus + Grafana</h1>
        <p><strong>Hostname:</strong> {hostname}</p>
        <p><strong>Version:</strong> {version}</p>
        <p><strong>Miljö:</strong> {environment}</p>
        <p><strong>Metrics:</strong> <a href="/metrics">/metrics</a></p>
    </body>
    </html>
    """

@app.route("/health")
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
