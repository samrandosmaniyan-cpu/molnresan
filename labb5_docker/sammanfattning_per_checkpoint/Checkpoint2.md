## Sammanfattning Avsnitt 2: Vad jag gjorde

Jag byggde en Docker-image från min Dockerfile och testade containern lokalt på min Mac.

**Kommandon jag körde:**

- `docker build -t labb5-app:1.0.0 .` – byggde en image från Dockerfile (varje rad i Dockerfile blev ett cachat lager)
- `docker run -d -p 8080:5000 --name labb5-test labb5-app:1.0.0` – startade en container i bakgrunden med port-mapping
- `docker ps` – verifierade att containern körde
- `docker logs labb5-test` – kollade appens logg-output
- `docker exec -it labb5-test /bin/bash` – gick in i containern (som SSH fast för containrar)
- `docker stop/rm` – stoppade och raderade containern

**Vad jag verifierade:**

1. Webbsidan svarade på `http://localhost:8080` med dynamisk info (hostname, version, miljö)
2. Health check-endpointen svarade med "OK" på `/health`
3. **Miljövariabler** – startade samma image med `-e APP_VERSION=2.0.0 -e ENVIRONMENT=staging` och fick annan output utan att bygga om
4. **Inuti containern** – hostname var containerns ID (inte min Mac), OS var Debian (inte macOS), Python 3.12 installerat av bas-imagen
5. **Cache-optimering** – vid ombyggnad efter kodändring cachades steg 1-4 och bara steg 5 (COPY app.py) kördes om

**Nya koncept jag lärde mig:**

- **`docker build -t namn:version .`** – bygg en image med tagg från nuvarande mapp
- **`docker run -d -p host:container`** – port-mapping kopplar en port på min dator till en port inuti containern
- **`-e VARIABEL=värde`** – sätt miljövariabler vid container-start utan att bygga om
- **`docker exec -it`** – öppna ett shell inuti en körande container
- **Docker lager-cache** – varje Dockerfile-rad blir ett cachat lager som återanvänds vid ombyggnad
- **Image-versionering** – flera taggar (1.0.0, 1.1.0) av samma app kan existera samtidigt

**Vad som är kvar:**

- Pusha imagen till Amazon ECR i Avsnitt 3
- Uppdatera Terraform i Avsnitt 4
- Deploy och verifiering i Avsnitt 5