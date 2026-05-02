## Sammanfattning Avsnitt 4: Vad jag gjorde

**Hela labb 4 sammanfattat:**

Jag byggde ett komplett eget nätverk (VPC) i AWS med Terraform, med publika och privata subnät i två Availability Zones. EC2-instansen placerades i ett publikt subnät (nåbar från internet) och RDS-databasen i ett privat subnät (ingen route till internet alls).

**Resurser jag skapade (18 totalt):**

- **Network-modulen (13 st):** VPC, Internet Gateway, 2 publika subnät, 2 privata subnät, 2 route tables, 4 route table-associationer, 1 DB subnet group
- **Webstack-modulen (5 st):** 2 security groups, 1 key pair, 1 EC2-instans, 1 RDS-databas

**Nya koncept jag lärde mig:**

- **VPC från grunden** – eget IP-intervall (10.0.0.0/16), egna subnät, egen routing
- **Publikt vs privat subnät** – skillnaden är route tabellen, inte brandväggen. Publikt subnät har route till Internet Gateway, privat har det inte.
- **Defense in depth** – databasen skyddas av *både* nätverkstopologi (ingen route) *och* security groups. Två oberoende skyddslager.
- **Moduler som samverkar** – network-modulens outputs blev webstack-modulens inputs, kopplade ihop i root-modulen
- **`count` + `length()`** – skapade flera subnät med en enda resource-block
- **Splat expression `[*]`** – hämtade attribut från alla element i en lista
- **DB Subnet Group** – berättar för RDS vilka privata subnät den får använda
- **Terraform löser beroendegrafen i båda riktningarna** – skapar i rätt ordning, river i omvänd ordning

**Jämförelse med tidigare Labb:**

| Labb | Nätverket | Databasskydd |
|------|-----------|--------------|
| labb 1-3 | Default-VPC, allt publikt | Bara security groups (1 lager) |
| labb 4 | Egen VPC, publika + privata subnät | Security groups + nätverksisolering (2 lager) |
