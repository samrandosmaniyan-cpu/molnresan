## Sammanfattning Avsnitt 0: Vad jag lärde mig

Jag lärde mig grundkoncepten för GitHub Actions innan jag började skriva någon kod.

**De fem grundbegreppen:**

1. **Workflow** – en automatiserad process definierad i en YAML-fil under `.github/workflows/`
2. **Event (trigger)** – vad som startar workflow:en (push, pull_request, manuell start)
3. **Job** – en grupp steg som körs på en fräsch virtuell maskin (runner)
4. **Step** – en enskild åtgärd: antingen ett bash-kommando (`run:`) eller en färdig action (`uses:`)
5. **Action** – en återanvändbar byggsten från GitHub Marketplace (t.ex. `actions/checkout@v4`)

**Hur GitHub Actions fungerar bakom kulisserna:**

1. Jag pushar kod till GitHub
2. GitHub startar en fräsch Ubuntu-maskin
3. Maskinen kör mina steps i ordning
4. När allt är klart stängs maskinen ner
5. Loggar sparas och visas i GitHub-gränssnittet

**Hur AWS-credentials hanteras:**

Istället för `~/.aws/credentials` (som inte finns på GitHub:s runner) använder jag **GitHub Secrets** – krypterade variabler som lagras i repo-inställningarna och injiceras som miljövariabler vid körning. GitHub maskerar dem i alla loggar.

**YAML-syntax:**

- Indentering med mellanslag (inte tabbar), två mellanslag per nivå
- `-` markerar listitem
- `key: value` för nyckel-värde-par
- `name:`, `on:`, `jobs:`, `steps:` är de viktigaste nyckelorden

**Planen för labb 7:**

Jag automatiserar labb 4 (egen VPC) så att `terraform plan` körs automatiskt vid push och `terraform apply` körs vid merge till main. Allt via GitHub Actions – ingen manuell `terraform apply` från min dator.

**Vad som är kvar:**

- Skapa workflow-fil i Avsnitt 1
- Lägga till AWS-secrets i Avsnitt 2
- Testa med kodändring i Avsnitt 3
- PR-baserad apply i Avsnitt 4
- Testa hela flödet i Avsnitt 5