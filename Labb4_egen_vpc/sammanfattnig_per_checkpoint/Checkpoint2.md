## Sammanfattning Avsnitt 2: Vad jag gjorde

Jag skapade dev-miljön som kopplar ihop network-modulen och webstack-modulen.

**Konkret skapade jag dessa filer:**

- `environments/dev/providers.tf` – AWS-provider med Stockholm-region och lokal backend
- `environments/dev/variables.tf` – region och db_password som inputs
- `environments/dev/main.tf` – anropar båda modulerna och kopplar ihop dem
- `environments/dev/outputs.tf` – re-exporterar outputs från båda modulerna
- `environments/dev/terraform.tfvars` – dev-specifikt databaslösenord

**Den centrala kopplingen (tre rader i main.tf):**

```hcl
vpc_id               = module.network.vpc_id
public_subnet_id     = module.network.public_subnet_ids[0]
db_subnet_group_name = module.network.db_subnet_group_name
```

Dessa tre rader tar outputs från network-modulen och skickar dem som inputs till webstack-modulen. Det är så moduler samverkar – genom explicita kopplingar i root-modulen.

**Nytt koncept jag lärde mig:**

- **Moduler som samverkar** – en moduls output blir en annan moduls input
- **Terraform beräknar ordningen automatiskt** – den ser beroendena och skapar nätverket före applikationen
- **`module.network.public_subnet_ids[0]`** – man kan indexera listor som returneras från moduler

**Vad som är kvar:**

- Deploy och verifiering i Avsnitt 3
- Destroy i Avsnitt 4
