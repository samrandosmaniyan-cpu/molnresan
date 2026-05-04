## Sammanfattning Avsnitt 1: Vad jag gjorde

Jag skapade en GitHub Actions workflow-fil som automatiskt kör `terraform plan` vid push till main.

**Konkret skapade jag:**

- `.github/workflows/terraform-labb4.yml` – en komplett workflow med 10 steg

**Workflow:ens 10 steg:**

1. **Checka ut kod** – `actions/checkout@v4` klonar repot till runnern
2. **Installera Terraform** – `hashicorp/setup-terraform@v3` med pinnad version 1.14.8
3. **Konfigurera AWS-credentials** – `aws-actions/configure-aws-credentials@v4` med GitHub Secrets
4. **Generera temporär SSH-nyckel** – nyckeln finns inte på runnern (gitignored), så jag genererar en ny varje körning
5. **Skapa terraform.tfvars** – skapas dynamiskt från en GitHub Secret (DB_PASSWORD)
6. **Terraform Init** – laddar providers och moduler
7. **Terraform Format Check** – `fmt -check` misslyckas om koden inte är formaterad (tvingar mig att formatera lokalt)
8. **Terraform Validate** – syntaxkontroll
9. **Terraform Plan** – visar vad som skulle skapas/ändras
10. **Sammanfattning** – körs alltid, oavsett om tidigare steg lyckades

**Triggers jag konfigurerade:**

- `push` till `main` – men *bara* om filer i `labb4_egen_vpc/` eller workflow-filen ändrats (`paths`-filter)
- `workflow_dispatch` – manuell start via knapp i GitHub-gränssnittet

**Nya koncept jag lärde mig:**

- **YAML-syntax** – indentering med mellanslag, `|` för multiline-kommandon
- **`uses:` vs `run:`** – färdiga actions vs egna bash-kommandon
- **`${{ secrets.NAMN }}`** – referera till krypterade variabler i GitHub
- **`${{ env.NAMN }}`** – referera till miljövariabler definierade i workflow:en
- **`paths:`-filter** – trigga workflow bara vid ändringar i specifika mappar
- **`defaults: run: working-directory:`** – sätt arbetskatalog för alla run-steg
- **`if: always()`** – kör steget oavsett om tidigare steg lyckades
- **`-no-color`** – ta bort ANSI-färgkoder för renare GitHub-loggar
- **`fmt -check`** – kontrollera formatering utan att ändra (CI/CD-lämpligt)
- **Temporära filer i CI/CD** – SSH-nycklar och tfvars skapas dynamiskt från secrets, aldrig committade

**Vad som är kvar:**

- Lägga till AWS-secrets i GitHub (Avsnitt 2)
- Testa workflow:en (Avsnitt 3)
- PR-baserad apply (Avsnitt 4)
- Testa hela flödet (Avsnitt 5)