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
6. **Granted Azure RBAC permissions:**
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

   # Resource Policy Contributor at tenant root (for policy definition operations)
   az role assignment create \
     --assignee "9ad476c4-b845-40e3-a46f-0a77984b1a57" \
     --role "Resource Policy Contributor" \
     --scope "/providers/Microsoft.Management/managementGroups/90d27970-b92c-43dc-9935-1ed557d8e20e"
   ```
7. **Added Federated Credential for GitHub OIDC:**
   ```bash
   APP_OBJECT_ID=$(az ad app show --id "9ad476c4-b845-40e3-a46f-0a77984b1a57" --query id -o tsv)

   # For environment-based deployments (works for both PRs and main branch)
   az ad app federated-credential create --id "$APP_OBJECT_ID" --parameters '{
     "name": "github-environment-dev",
     "issuer": "https://token.actions.githubusercontent.com",
     "subject": "repo:KrijnvanderBurg/my-cloud:environment:dev",
     "audiences": ["api://AzureADTokenExchange"]
   }'
   ```
8. **Granted User Access Administrator for subscription association:**
   ```bash
   # Required to move subscriptions between management groups (needs Microsoft.Authorization/roleAssignments/write)
   az role assignment create \
     --assignee "9ad476c4-b845-40e3-a46f-0a77984b1a57" \
     --role "User Access Administrator" \
     --scope "/providers/Microsoft.Management/managementGroups/90d27970-b92c-43dc-9935-1ed557d8e20e"
   ```
9. **Granted Billing permissions for subscription creation (Portal only):**
   > Billing permissions cannot be assigned via Azure CLI or Terraform — Portal only.
   1. Go to **Azure Portal** → **Cost Management + Billing**
   2. Navigate to **Access control (IAM)**
   3. Click **+ Add**
   4. Select role: **Billing account contributor**
   5. Select the CI/CD service principal (`github-opentofu-deployment` / `9ad476c4-b845-40e3-a46f-0a77984b1a57`)
   6. Add + save
