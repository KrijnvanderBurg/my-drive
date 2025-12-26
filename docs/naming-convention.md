# Azure Naming Convention

Based on [Azure Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming).

## Format

```
<type>-<workload>-<env>-<region>-<instance>
```

**All resources follow this format, including management groups and subscriptions.**

## Components

| Component | Description | Examples |
|-----------|-------------|----------|
| Type | Azure abbreviation | `mg`, `sub`, `rg`, `st`, `vnet` |
| Workload | Application/project name | `myproject`, `network`, `platform` |
| Env | Deployment stage | `dev`, `tst`, `prd` |
| Region | Azure region or `glb` for multi-region | `weu`, `gwc`, `glb` |
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

## Examples

### Management Groups
```
mg-myproject-prd-glb-01      # Root/top-level (global scope)
mg-platform-prd-glb-01       # Platform services
mg-workloads-prd-glb-01      # Workload subscriptions
mg-sandbox-dev-glb-01        # Sandbox/dev
```

### Subscriptions
```
sub-management-prd-glb-01    # Management subscription (multi-region)
sub-platform-prd-weu-01      # Platform in West Europe
sub-workloads-prd-gwc-01     # Workloads in Germany West Central
sub-sandbox-dev-glb-01       # Sandbox (multi-region)
```

### Resource Groups
```
rg-tfstate-prd-weu-01
rg-network-prd-weu-01
rg-app-dev-weu-01
```

### Storage Accounts (no hyphens, max 24 chars)
```
sttfstateprdweu01
stappdevweu01
```

### Virtual Networks
```
vnet-hub-prd-weu-01
vnet-spoke-dev-weu-01
```

### Virtual Machines
```
vm-web-prd-weu-01
vm-sql-dev-weu-01
```

## Notes

- **All resources** use the same format: `<type>-<workload>-<env>-<region>-<instance>`
- Use `glb` for resources spanning multiple regions
- Storage accounts: no hyphens, lowercase, max 24 chars
- Instance numbers: 2 digits (`01`, `02`)
- Environment: `dev`, `test`, `prod`
