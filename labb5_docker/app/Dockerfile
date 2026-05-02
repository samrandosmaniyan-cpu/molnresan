# Steg 1: Välj bas-image
FROM python:3.12-slim

# Steg 2: Sätt arbetskataloginuti containern
WORKDIR /app

# Steg 3: Kopiera beroende-filen och installera
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Steg 4: Kopiera applikationskoden
COPY app.py .

# Steg 5: Exponera porten appen lyssnar på
EXPOSE 5000

# Steg 6: Definiera miljövariabler med defaults
ENV APP_VERSION=1.0.0
ENV ENVIRONMENT=dev

# Steg 7: Kommandot som körs när containern startar
CMD ["python", "app.py"]