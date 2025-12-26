# Terraform Multi-Environment Setup

## Structure

```
environments/
├── dev/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
├── staging/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
└── prod/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── terraform.tfvars
```

## Usage

### Dev
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### Staging
```bash
cd environments/staging
terraform init
terraform plan
terraform apply
```

### Prod
```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```
