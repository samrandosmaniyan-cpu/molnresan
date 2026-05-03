## Sammanfattning Avsnitt 3: Vad jag gjorde

Jag skapade ett privat container-registry i AWS (Amazon ECR), pushade min Docker-image dit, och verifierade att den kan hämtas igen.

**Kommandon jag körde:**

- `aws ecr create-repository --repository-name labb5-app --region eu-north-1 ...` – skapade ett privat ECR-repo med automatisk sårbarhetsskanning aktiverat
- `aws ecr get-login-password | docker login --username AWS --password-stdin <registry-url>` – autentiserade Docker mot ECR med en 12-timmars token
- `docker tag labb5-app:1.1.0 <registry-url>/labb5-app:1.1.0` – taggade min lokala image med ECR:s fulla URI
- `docker push <registry-url>/labb5-app:1.1.0` – pushade imagen till ECR
- `docker tag` + `docker push` igen för `latest`-taggen
- `docker rmi` + `docker pull` – raderade lokal image och hämtade tillbaka från ECR för att verifiera

**Vad jag verifierade:**

1. ECR-repot finns synligt i AWS-konsolen
2. Två taggar pushade: `1.1.0` och `latest` med samma underliggande image
3. Image kan pullas från ECR och köras lokalt
4. Sårbarhetsskanning kör automatiskt vid push

**Nya koncept jag lärde mig:**

- **Amazon ECR** – privat container-registry inuti AWS, integrerat med IAM
- **Image URI-format** – `<account-id>.dkr.ecr.<region>.amazonaws.com/<repo>:<tag>`
- **`docker tag`** – skapar en ny "alias" för en befintlig image (samma IMAGE ID, två namn)
- **`docker login` med STDIN** – säkrare sätt att skicka lösenord via pipe istället för kommandorad
- **ECR-autentiseringstoken** – giltig i 12 timmar, måste förnyas dagligen vid manuellt arbete
- **Image-lager pushas oberoende** – Docker pushar bara nya lager, befintliga återanvänds
- **`scanOnPush=true`** – ECR scannar automatiskt efter sårbarheter
- **`MUTABLE` vs `IMMUTABLE`** – om en tag (som `latest`) får skrivas över. Produktion väljer ofta IMMUTABLE för säkerhet.
- **`latest`-taggens fara** – bekvämt men kan orsaka oväntade versionsbyten i produktion

**Vad som är kvar:**

- Uppdatera Terraform så EC2 hämtar och kör containern (Avsnitt 4)
- IAM-roll för EC2 så den kan autentisera mot ECR utan lösenord (Avsnitt 4)
- Deploy och verifiering (Avsnitt 5)
- Destroy och reflektion (Avsnitt 6)