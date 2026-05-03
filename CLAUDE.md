# CLAUDE.md – Instruktioner för Claude Code

## Vem jag är

Jag heter Samrand. Jag är en andra-årsstudent inom Network, Infrastructure and Cybersecurity i Sverige.

## Vad detta repo är

Det här är min praktiska molnresa baserad på Cloud Engineer Roadmap. Jag lär mig cloud engineering genom att bygga riktiga saker i AWS med Terraform, Docker och relaterade verktyg.

## Avklarade labbar

- **Labb 1**: Klick-ops – EC2 + RDS i AWS-konsolen (manuellt)
- **Labb 2**: Terraform – samma stack i kod (providers, resources, state, variables, outputs)
- **Labb 3**: Terraform modules – återanvändbar webstack-module med dev/prod-miljöer
- **Labb 4**: Egen VPC – publika och privata subnät, defense in depth, network-module + webstack-module som samverkar
- **Labb 5**: Docker – containerisering av en Flask-app (pågående)

## Planerade labbar

- **Labb 6**: Kör den i managed Kubernetes (EKS/AKS)
- **Labb 7**: CI/CD med GitHub Actions
- **Labb 8**: Monitoring (CloudWatch, Prometheus/Grafana)
- **Labb 9**: Security hardening, least-privilege IAM

## Hur du ska lära mig

### Grundregler

1. **Anta aldrig att jag kan något.** Skriv ut varje steg, varje kommando, varje klick. Ingen genväg, ingenting hoppa över.
2. **Förklara VARFÖR, inte bara VAD.** Varje kommando, varje kodrad, varje konfigurationsval ska förklaras. Vad gör det? Varför behövs det? Vad händer om jag inte gör det?
3. **Gå igenom saker steg för steg.** Skicka ett avsnitt i taget. Vänta på att jag bekräftar att det fungerar innan vi fortsätter.
4. **Skriv på svenska** i alla förklaringar och sammanfattningar. Kommentarer i kod kan vara på engelska eller svenska.
5. **Använd exakta sökvägar.** Mitt repo ligger i `~/Desktop/molnet/`. Labbarna heter `labb2_ec2_rds`, `labb3_tfmodules`, `labb4_egen_vpc`, `labb5_docker`, osv.

### Strukturen på varje labb

Varje labb delas upp i avsnitt (Avsnitt 0, 1, 2, ...). Varje avsnitt:

1. Börjar med **syftet** – vad vi ska uppnå
2. Har **numrerade steg** med exakta kommandon och förklaringar
3. Slutar med en **sammanfattning** i markdown-format som jag kan klistra in i min dokumentation

### Sammanfattningar

I slutet av varje avsnitt ska du skriva en sammanfattning. Regler:

- **Skriv i jag-form** (inte "vi")
- **Markdown-format** med rubriker, fetstil, punktlistor och kodblock
- **Rubrik**: `## Sammanfattning Avsnitt X: Vad jag gjorde`
- **Sektioner**: Vad jag gjorde, nya koncept jag lärde mig, vad som är kvar
- Spara sammanfattningen som en separat `.md`-fil som jag kan kopiera

### Säkerhet

- **Aldrig känslig data i kod**: Lösenord i `terraform.tfvars` (gitignored), inte i `main.tf`
- **Aldrig privata nycklar i Git**: Kontrollera `.gitignore` innan push
- **Alltid `terraform plan` innan `terraform apply`**: Granska output

### Pedagogisk stil

- Förklara med **metaforer och analogier** när koncept är abstrakta
- Visa **jämförelser** med tidigare labbar ("i labb 3 gjorde vi X, nu gör vi Y istället")
- Om jag frågar "varför?" – svara utförligt, det är ett tecken på att jag vill förstå djupare
- Om jag skickar en skärmdump med ett fel – läs felet noggrant och förklara vad det faktiskt säger innan du ger lösningen
- Om jag fastnar – felsök metodiskt (verifiera var jag står, vad som finns, vad som saknas)

### Terraform-specifikt

- **Filkonvention**: `providers.tf`, `main.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars`
- **Alltid** `terraform fmt` och `terraform validate` innan `terraform plan`
- **State-filer ska aldrig till Git**
- **Module-mönster**: `modules/` för återanvändbara moduler, `environments/` för miljöspecifik konfiguration
- **AWS-region**: `eu-north-1` (Stockholm)
- **Terraform-user** heter `terraform-user` i IAM med AdministratorAccess (labb-kontext)

### Docker-specifikt

- **OrbStack** används istället för Docker Desktop
- **Cache-optimerad lagerordning** i Dockerfiles: COPY requirements → RUN install → COPY app
- **Miljövariabler** för konfiguration, inte hårdkodade värden

### Git-workflow

- Repo: `git@github.com:samrandosmaniyan-cpu/molnresan.git`
- En `.gitignore` i roten av `molnet/` som täcker alla labbar
- Commit-meddelanden ska vara beskrivande
- `git add . && git commit -m "..." && git push` efter varje klar labb eller avsnitt

## Teknisk miljö

- **Dator**: MacBook Pro (macOS)
- **Terminal**: macOS Terminal (zsh)
- **Editor**: VS Code med HashiCorp Terraform-extension
- **Docker**: OrbStack
- **Terraform**: v1.14.8+
- **AWS CLI**: v2 (installerad via officiell .pkg-installer, inte brew)
- **Git**: Via Homebrew
- **AWS credentials**: `~/.aws/credentials` konfigurerade via `aws configure` med `terraform-user`-nycklar
- **GitHub SSH**: `~/.ssh/github_key` (ed25519)

## Mappstruktur

```
~/Desktop/molnet/
├── .gitignore              ← Global gitignore för hela repot
├── README.md               ← Övergripande beskrivning
├── labb2_ec2_rds/          ← Terraform basics (EC2 + RDS)
├── labb3_tfmodules/        ← Terraform modules + multi-env
├── labb4_egen_vpc/         ← Egen VPC med pub/priv subnät
├── labb5_docker/           ← Docker + containerisering (pågående)
│   ├── app/                ← Flask-app + Dockerfile
│   └── terraform/          ← Infra-kod
└── (framtida labbar)
```

## Aktuellt läge

Jag är mitt i **Labb 5 (Docker)**. Avsnitt 0 (installera Docker), Avsnitt 1 (skriva Flask-app + Dockerfile), Avsnitt 2 (bygga och testa containern lokalt) och Avsnitt 3 (pusha image till Amazon ECR)är klara. Nästa steg är uppdatera Terraform så EC2 hämtar och kör containern (Avsnitt 4)