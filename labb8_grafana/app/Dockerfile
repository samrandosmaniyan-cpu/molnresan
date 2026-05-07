FROM --platform=linux/amd64 python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

ENV FLASK_ENV=production

CMD ["python", "app.py"]
