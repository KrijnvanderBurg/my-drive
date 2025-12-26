# Azure - Levendaal
Terraform/OpenTofu configuration for Levendaal.

- See [docs/naming-convention.md](docs/naming-convention.md) for full naming standards.

## Deployment History
All steps performed to setup initial infrastructure and to current state.

1. **Created Azure Tenant** (`Levendaal`) via Azure Portal.
2. **Created Subscription** (`sub-management-dev-gwc-01`/`9312c5c5-b089-4b62-bb90-0d92d421d66c`) via Azure Portal
3. **Created Storage Account for remote tfstate:**
   ```bash
   az login
   az account set --subscription "9312c5c5-b089-4b62-bb90-0d92d421d66c"
   az group create --name "rg-tfstate-dev-gwc-01" --location "germanywestcentral"
   az storage account create --name "sttfstatedevgwc01" --resource-group "rg-tfstate-dev-gwc-01" --location "germanywestcentral" --sku "Standard_LRS"
   az storage container create --name "tfstate-management" --account-name "sttfstatedevgwc01"
   ```
4. **Configured backend** in `environments/dev/backend.tf`
5. **Created App Registration for GitHub Actions OIDC:**
   ```bash
   # Create app registration
   az ad app create --display-name "github-opentofu-deployment" --query appId -o tsv
   # Output: 9ad476c4-b845-40e3-a46f-0a77984b1a57

   # Create service principal
   az ad sp create --id "9ad476c4-b845-40e3-a46f-0a77984b1a57"
   ```
6. **Added Federated Credentials for GitHub OIDC:**
   ```bash
   APP_OBJECT_ID=$(az ad app show --id "9ad476c4-b845-40e3-a46f-0a77984b1a57" --query id -o tsv)

   # For main branch deployments
   az ad app federated-credential create --id "$APP_OBJECT_ID" --parameters '{
     "name": "github-main-branch",
     "issuer": "https://token.actions.githubusercontent.com",
     "subject": "repo:KrijnvanderBurg/my-drive:ref:refs/heads/main",
     "audiences": ["api://AzureADTokenExchange"]
   }'

   # For pull request plans
   az ad app federated-credential create --id "$APP_OBJECT_ID" --parameters '{
     "name": "github-pull-request",
     "issuer": "https://token.actions.githubusercontent.com",
     "subject": "repo:KrijnvanderBurg/my-drive:pull_request",
     "audiences": ["api://AzureADTokenExchange"]
   }'
   ```
7. **Granted Azure RBAC permissions:**
   ```bash
   # Contributor on subscription (for tfstate storage access)
   az role assignment create \
     --assignee "9ad476c4-b845-40e3-a46f-0a77984b1a57" \
     --role "Contributor" \
     --scope "/subscriptions/9312c5c5-b089-4b62-bb90-0d92d421d66c"

   # Management Group Contributor at tenant root (for management group operations)
   az role assignment create \
     --assignee "9ad476c4-b845-40e3-a46f-0a77984b1a57" \
     --role "Management Group Contributor" \
     --scope "/providers/Microsoft.Management/managementGroups/90d27970-b92c-43dc-9935-1ed557d8e20e"
   ```
