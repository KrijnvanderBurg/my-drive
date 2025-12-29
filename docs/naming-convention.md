# Azure Naming Convention

Based on [Azure Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming) and [Azure Landing Zone architecture](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/).

## Format

```
<type>-<workload>-<archetype>-<env>-<region>-<instance>
```

## Components

| Component | Description | Examples |
|-----------|-------------|----------|
| Type | Subscription layer: <br> OR Azure resource abbreviation: | `pl`, `plz`, `alz`, <br> `mg`, `rg`, `st`, `vnet`, `vm` |
| Workload | Function or application name | `management`, `identity`, `connectivity`, `dataplatform`, `webapp`, `erp` |
| Archetype | Network/security posture | `co`, `on` |
| Env | Deployment stage | `dev`, `test`, `accp`, `prod` |
| Region | Azure region or `glb` for global or `na` if no region | `weu`, `gwc`, `glb`, `na` |
| Instance | Number (2 digits) | `01`, `02` |

## Region Abbreviations

| Region | Abbreviation |
|--------|--------------|
| Global / Multi-region | `glb` |
| Germany West Central | `gwc` |
| West Europe | `weu` |
| North Europe | `neu` |

## Resource Abbreviations

| Resource | Abbreviation |
|----------|--------------|
| Management group | `mg` |
| Subscription | `sub` |
| Resource group | `rg` |
| Storage account | `st` (no hyphens) |
| Datalake (HNS enabled) | `dls` (no hyphens) |
| Virtual network | `vnet` |
| Subnet | `snet` |
| Network security group | `nsg` |
| Virtual machine | `vm` |
| Key vault | `kv` |
| AKS cluster | `aks` |
| Log Analytics workspace | `log` |
| Automation account | `aa` |
| Firewall | `afw` |
| VPN Gateway | `vpng` |
| ExpressRoute Gateway | `ergw` |
| Bastion | `bas` |
| Private DNS Zone | `pdnsz` |

## Archetypes

Landing zones use archetypes to define security/network posture:

| Archetype | Description | Use case |
|-----------|-------------|----------|
| `co` | Corp - No direct internet access, internal only | ERP, internal APIs, databases |
| `on` | Online - Public internet access allowed | Public websites, customer APIs |
