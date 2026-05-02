from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route("/")
def home():
    hostname = socket.gethostname()
    version = os.environ.get("APP_VERSION", "1.0.0")
    environment = os.environ.get("ENVIRONMENT", "unknown")

    return f"""
    <html>
    <head><title>Labb 5 - Dockeriserad app</title></head>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 50px auto;">
        <h1>HejHejHej!</h1>
        <p><strong>Hostname:</strong> {hostname}</p>
        <p><strong>Version:</strong> {version}</p>
        <p><strong>Miljö:</strong> {environment}</p>
        <p><strong>Kör i:</strong> Docker på EC2</p>
    </body>
    </html>
    """

@app.route("/health")
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)