## Sammanfattning Avsnitt 1: Vad jag gjorde

Jag skapade en enkel Python-webbapplikation och en Dockerfile som paketerar den.

**Konkret skapade jag dessa filer:**

- `app/app.py` – en Flask-webbapp med två endpoints: `/` (startsida med dynamisk info) och `/health` (health check som returnerar "OK")
- `app/requirements.txt` – Python-beroenden (bara Flask)
- `app/Dockerfile` – receptet för att bygga en container-image
- `app/.dockerignore` – filer som inte ska kopieras in i containern

**Nya koncept jag lärde mig:**

- **Dockerfile** – en textfil med instruktioner som bygger en container-image lager för lager
- **FROM** – väljer bas-image (Python 3.12-slim i mitt fall)
- **WORKDIR** – sätter arbetskatalog inuti containern
- **COPY** – kopierar filer från min dator till containern
- **RUN** – kör kommandon *under bygget* (t.ex. installera beroenden)
- **CMD** – kommandot som körs *vid container-start* (t.ex. starta appen)
- **EXPOSE** – dokumenterar vilken port appen lyssnar på
- **ENV** – sätter default-miljövariabler som kan överridas vid körning
- **Cache-optimerad lagerordning** – COPY requirements.txt + RUN pip install *före* COPY app.py gör att beroenden inte installeras om vid kodändringar
- **Health check-endpoint** – standard-pattern i moderna applikationer för att monitoring-verktyg ska kunna kolla om appen lever
- **Miljövariabler för konfiguration** – `os.environ.get()` gör att samma image kan köras med olika inställningar utan ombyggnad

**Vad som är kvar:**

- Bygga och testa containern lokalt i Avsnitt 2
- Pusha imagen till Amazon ECR i Avsnitt 3
- Uppdatera Terraform i Avsnitt 4
- Deploy och verifiering i Avsnitt 5