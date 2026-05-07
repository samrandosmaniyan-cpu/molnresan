## Sammanfattning Avsnitt 2: Vad jag gjorde

Jag lagrade AWS-credentials och databaslösenord som krypterade secrets i GitHub och testade att workflow:en kunde köra `terraform plan` automatiskt.

**Secrets jag skapade i GitHub:**

- `AWS_ACCESS_KEY_ID` – access key för terraform-user
- `AWS_SECRET_ACCESS_KEY` – secret key för terraform-user
- `DB_PASSWORD` – databaslösenord som används i terraform.tfvars

**Steg jag följde:**

1. Navigerade till repots Settings → Secrets and variables → Actions
2. La till tre repository secrets via "New repository secret"
3. Verifierade att alla tre syns i listan (värden dolda)
4. Triggade workflow:en manuellt via "Run workflow"-knappen
5. Följde körningen live i GitHub Actions-gränssnittet
6. Alla 10 steg lyckades och `terraform plan` visade `Plan: 18 to add`

**Hur secrets fungerar:**

- GitHub krypterar varje secret med ett repo-specifikt nyckelpar
- Vid workflow-körning dekrypteras de och injiceras som miljövariabler
- Om en secret råkar skrivas ut i loggar ersätts den med `***`
- Secrets skickas aldrig till fork:ade repos
- Värdena kan aldrig ses igen – bara uppdateras eller tas bort

**Nya koncept jag lärde mig:**

- **GitHub Repository Secrets** – krypterad lagring för känsliga värden
- **`${{ secrets.NAMN }}`** – syntax för att referera till secrets i workflow-filer
- **`workflow_dispatch`** – möjlighet att trigga workflows manuellt via en knapp i GitHub-gränssnittet
- **Automatisk maskering** – GitHub ersätter secret-värden med `***` i alla loggar
- **Settings → Secrets and variables → Actions** – var secrets konfigureras

**Vad som är kvar:**

- Testa workflow:en med en riktig kodändring i Avsnitt 3
- PR-baserad apply i Avsnitt 4
- Testa hela flödet i Avsnitt 5