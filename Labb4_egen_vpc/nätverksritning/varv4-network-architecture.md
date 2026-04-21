# Varv 4: Nätverksarkitektur – Egen VPC

## Översikt

En komplett VPC-arkitektur med publika och privata subnät, designad för tvåskiktsapplikationer (webserver + databas) med defense-in-depth.

## Nätverksdiagram

```
┌──────────────────────────────────────────────────────────────────┐
│  VPC: 10.0.0.0/16                                                │
│                                                                  │
│  ┌─────────────────────────┐  ┌─────────────────────────┐        │
│  │  Public Subnet 1        │  │  Public Subnet 2        │        │
│  │  10.0.1.0/24            │  │  10.0.2.0/24            │        │
│  │  AZ: eu-north-1a        │  │  AZ: eu-north-1b        │        │
│  │                         │  │                         │        │
│  │   ┌─────────────────┐   │  │                         │        │
│  │   │  EC2 (Nginx)    │   │  │   (Redo för framtida    │        │
│  │   │  web-sg         │   │  │    Load Balancer)       │        │
│  │   └─────────────────┘   │  │                         │        │
│  └────────────┬────────────┘  └─────────────────────────┘        │
│               │                                                  │
│           Internet Gateway ◄──── Route: 0.0.0.0/0 → IGW         │
│               │                                                  │
│  ═════════════╪══════════════════════════════════════════         │
│    Ingen route till internet nedanför denna linje                │
│  ═════════════╪══════════════════════════════════════════         │
│               │                                                  │
│  ┌────────────┴────────────┐  ┌─────────────────────────┐        │
│  │  Private Subnet 1       │  │  Private Subnet 2       │        │
│  │  10.0.10.0/24           │  │  10.0.20.0/24           │        │
│  │  AZ: eu-north-1a        │  │  AZ: eu-north-1b        │        │
│  │                         │  │                         │        │
│  │   ┌─────────────────┐   │  │                         │        │
│  │   │  RDS MySQL      │   │  │   (Standby-subnät      │        │
│  │   │  db-sg          │   │  │    för RDS failover)   │        │
│  │   └─────────────────┘   │  │                         │        │
│  └─────────────────────────┘  └─────────────────────────┘        │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

## Trafikflöde

```
Internet ──── HTTP/SSH ────► EC2 i publikt subnät     ✅ Tillåtet via IGW + web-sg
Internet ──── MySQL ────►    RDS i privat subnät      ✗  Blockerat (ingen route)
EC2      ──── MySQL ────►    RDS internt via VPC      ✅ Tillåtet via db-sg
```

## Subnätplan

| Subnät | CIDR | Typ | AZ | Syfte |
|--------|------|-----|----|-------|
| Public Subnet 1 | 10.0.1.0/24 | Public | eu-north-1a | EC2, Load Balancer |
| Public Subnet 2 | 10.0.2.0/24 | Public | eu-north-1b | Redundans, framtida LB |
| Private Subnet 1 | 10.0.10.0/24 | Private | eu-north-1a | RDS primär |
| Private Subnet 2 | 10.0.20.0/24 | Private | eu-north-1b | RDS standby/failover |

## Route Tables

### Public Route Table
| Destination | Target | Syfte |
|-------------|--------|-------|
| 10.0.0.0/16 | local | Intern VPC-trafik |
| 0.0.0.0/0 | Internet Gateway | Trafik till/från internet |

### Private Route Table
| Destination | Target | Syfte |
|-------------|--------|-------|
| 10.0.0.0/16 | local | Intern VPC-trafik |
| *(ingen default route)* | — | Ingen väg till internet |

## Security Groups

### web-sg (EC2)
| Riktning | Port | Protokoll | Källa | Syfte |
|----------|------|-----------|-------|-------|
| Inbound | 22 | TCP | Min IP (/32) | SSH-åtkomst |
| Inbound | 80 | TCP | 0.0.0.0/0 | HTTP från internet |
| Outbound | Alla | Alla | 0.0.0.0/0 | All utgående trafik |

### db-sg (RDS)
| Riktning | Port | Protokoll | Källa | Syfte |
|----------|------|-----------|-------|-------|
| Inbound | 3306 | TCP | web-sg | MySQL bara från EC2 |
| Outbound | Alla | Alla | 0.0.0.0/0 | All utgående trafik |

## Jämförelse: Default-VPC vs Egen VPC

| Aspekt | Default-VPC | Egen VPC (varv 4) |
|--------|-------------|-------------------|
| Subnät-typ | Alla publika | Publika + privata |
| Databas-skydd | Bara security group | Security group + nätverksisolering |
| IP-intervall | 172.31.0.0/16 (AWS-valt) | 10.0.0.0/16 (eget val) |
| Route tables | En delad | Separata per subnät-typ |
| Antal skyddslager | 1 (SG) | 2 (SG + nätverkstopologi) |
| Produktionsklar | Nej | Ja |

## Designprinciper

- **Defense in depth**: Flera oberoende skyddslager (nätverksisolering + security groups)
- **Hög tillgänglighet**: Resurser spridda över minst 2 Availability Zones
- **Least privilege**: Privata subnät har ingen internet-access om det inte explicit behövs
- **Separation of concerns**: Nätverket (network-module) är separat från applikationen (webstack-module)
