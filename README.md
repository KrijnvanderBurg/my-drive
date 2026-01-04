# Azure - Levendaal
Terraform/OpenTofu configuration for Levendaal.

- See [docs/naming-convention.md](docs/naming-convention.md) for full naming standards.

## Deployment History
All steps performed to setup initial infrastructure and to current state.

1. **Created Azure Tenant** (`Levendaal`) via Azure Portal.
2. **Created Subscription** (`pl-management-co-dev-na-01`/`e388ddce-c79d-4db0-8a6f-cd69b1708954`) via Azure Portal
3. **Created Storage Account for remote tfstate:**
   ```bash
   az login
   az account set --subscription "e388ddce-c79d-4db0-8a6f-cd69b1708954"
   az group create --name "rg-tfstate-co-dev-gwc-01" --location "germanywestcentral"
   az storage account create --name "sttfstatecodevgwc01" --resource-group "rg-tfstate-co-dev-gwc-01" --location "germanywestcentral" --sku "Standard_LRS"
   az storage container create --name "tfstate-pl-management" --account-name "sttfstatecodevgwc01"
   az storage container create --name "tfstate-pl-identity" --account-name "sttfstatecodevgwc01"
   ```
4. **Configured backend** in `environments/dev/backend.tf`
5. **Created App Registration for GitHub Actions OIDC:**
   ```bash
   # Create app registration
   az ad app create --display-name "github-opentofu-deployment" --query appId -o tsv
   # Output: 167a99fd-6289-4088-a9e0-dd2dc1a2c509

   # Create service principal
   az ad sp create --id "167a99fd-6289-4088-a9e0-dd2dc1a2c509"
   ```
6. **Granted Azure RBAC permissions:**
   ```bash
   # Contributor on subscription (for tfstate storage access)
   az role assignment create \
     --assignee "167a99fd-6289-4088-a9e0-dd2dc1a2c509" \
     --role "Contributor" \
     --scope "/subscriptions/e388ddce-c79d-4db0-8a6f-cd69b1708954"

   # Management Group Contributor at tenant root (for management group operations)
   az role assignment create \
     --assignee "167a99fd-6289-4088-a9e0-dd2dc1a2c509" \
     --role "Management Group Contributor" \
     --scope "/providers/Microsoft.Management/managementGroups/90d27970-b92c-43dc-9935-1ed557d8e20e"

   # Resource Policy Contributor at tenant root (for policy definition operations)
   az role assignment create \
     --assignee "167a99fd-6289-4088-a9e0-dd2dc1a2c509" \
     --role "Resource Policy Contributor" \
     --scope "/providers/Microsoft.Management/managementGroups/90d27970-b92c-43dc-9935-1ed557d8e20e"
   ```
7. **Added Federated Credential for GitHub OIDC:**
   ```bash
   APP_OBJECT_ID=$(az ad app show --id "167a99fd-6289-4088-a9e0-dd2dc1a2c509" --query id -o tsv)

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
     --assignee "167a99fd-6289-4088-a9e0-dd2dc1a2c509" \
     --role "User Access Administrator" \
     --scope "/providers/Microsoft.Management/managementGroups/90d27970-b92c-43dc-9935-1ed557d8e20e"
   ```
9. **Granted Billing permissions for subscription creation (Portal only):**
   Billing permissions cannot be assigned via Azure CLI or Terraform — Portal only.
   1. Go to **Azure Portal** → **Cost Management + Billing**
   2. Navigate to **Access control (IAM)**
   3. Click **+ Add**
   4. Select role: **Billing account contributor**
   5. Select the CI/CD service principal (`github-opentofu-deployment` / `167a99fd-6289-4088-a9e0-dd2dc1a2c509`)

10. **Granted Microsoft Graph API permissions for Entra ID management (Portal only):**
    Required for managing Entra ID resources (groups).
    1. Go to **Azure Portal** → **Entra ID** → **App registrations**
    2. Find `github-opentofu-deployment` (`167a99fd-6289-4088-a9e0-dd2dc1a2c509`)
    3. Navigate to **API permissions** → **Add a permission**
    4. Select **Microsoft Graph** → **Application permissions**
    5. Add the following permissions:
       - `Group.ReadWrite.All` - Create and manage security groups
    6. Click **Grant admin consent for [tenant name]** (CRITICAL - must click this button)

---

## Important Notes

### Entra ID Premium Licensing

This deployment uses **only free tier Entra ID features**:
- ✅ Security groups (non-role-assignable, for Azure RBAC)
- ✅ Azure Monitor alerts (administrative activity)
- ❌ Conditional Access policies (requires Premium P1/P2)
- ❌ Named locations (requires Premium P1/P2)
- ❌ Role-assignable groups (requires Premium P1/P2)

**Current deployment includes:**
- Security group for platform contributors (`sg-rbac-platform-contributors-dev-na-01`)
- Resource group for monitoring
- Action group for email alerts
- Activity log alert for role assignment changes

---

## Service Principal Documentation

### github-opentofu-deployment

**Purpose:** CI/CD service principal for OpenTofu deployments via GitHub Actions OIDC.

| Property | Value |
|----------|-------|
| App ID | `167a99fd-6289-4088-a9e0-dd2dc1a2c509` |
| Display Name | `github-opentofu-deployment` |
| Authentication | OIDC federated credential |
| Subject | `repo:KrijnvanderBurg/my-cloud:environment:dev` |

**Azure RBAC Roles:**
- Contributor on management subscription
- Management Group Contributor at tenant root
- Resource Policy Contributor at tenant root
- User Access Administrator at tenant root

**Microsoft Graph API Permissions:**
- `Application.Read.All`
- `Group.ReadWrite.All`
- `Policy.Read.All`
- `Policy.Read.ConditionalAccess`
- `Policy.ReadWrite.ConditionalAccess`

---

## Managing Users and Groups

### Adding Users to Platform Contributors Group

Users in `sg-rbac-platform-contributors-dev-na-01` will have Contributor access to platform subscriptions once RBAC assignments are configured.

**Via Azure Portal:**
1. Go to **Entra ID** → **Groups**
2. Search for `sg-rbac-platform-contributors-dev-na-01`
3. Click **Members** → **Add members**
4. Select users and click **Select**

**Via Azure CLI:**
```bash
# Get group object ID
GROUP_ID=$(az ad group show --group "sg-rbac-platform-contributors-dev-na-01" --query id -o tsv)

# Add user to group
az ad group member add --group $GROUP_ID --member-id <user-object-id>
```

---
