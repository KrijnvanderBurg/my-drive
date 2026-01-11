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
5. **Created sp-platform-identity Service Principal (Manual - Cannot Manage Itself):**
    ```bash
    # 1. Create the app registration
    az ad app create \
      --display-name "sp-platform-identity-co-dev-na-01" \
      --sign-in-audience AzureADMyOrg

    # Capture the appId (client ID) - you'll need this
    APP_ID=$(az ad app list --display-name "sp-platform-identity-co-dev-na-01" --query "[0].appId" -o tsv)
    echo "App ID: $APP_ID"

    # 2. Create service principal
    az ad sp create --id $APP_ID

    # Get object IDs for later
    SP_OBJECT_ID=$(az ad sp show --id $APP_ID --query "id" -o tsv)
    APP_OBJECT_ID=$(az ad app show --id $APP_ID --query "id" -o tsv)
    echo "SP Object ID: $SP_OBJECT_ID"
    echo "App Object ID: $APP_OBJECT_ID"

    # 3. Create federated credential for GitHub Actions
    az ad app federated-credential create \
      --id $APP_OBJECT_ID \
      --parameters '{
        "name": "github-federation-0",
        "issuer": "https://token.actions.githubusercontent.com",
        "subject": "repo:KrijnvanderBurg/my-cloud:environment:dev",
        "audiences": ["api://AzureADTokenExchange"]
      }'

    # 4. Assign Graph API permissions
    # Application.ReadWrite.All
    az ad app permission add \
      --id $APP_ID \
      --api 00000003-0000-0000-c000-000000000000 \
      --api-permissions 1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9=Role

    # Group.ReadWrite.All
    az ad app permission add \
      --id $APP_ID \
      --api 00000003-0000-0000-c000-000000000000 \
      --api-permissions 62a82d76-70ea-41e2-9197-370581804d09=Role

    # RoleManagement.ReadWrite.Directory
    az ad app permission add \
      --id $APP_ID \
      --api 00000003-0000-0000-c000-000000000000 \
      --api-permissions 9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8=Role

    # 5. Grant admin consent (requires Global Admin or Privileged Role Admin)
    az ad app permission admin-consent --id $APP_ID

    # 6. Assign Azure RBAC roles
    TENANT_ROOT_ID="90d27970-b92c-43dc-9935-1ed557d8e20e"
    IDENTITY_SUB_ID="9312c5c5-b089-4b62-bb90-0d92d421d66c"
    TFSTATE_SUB_ID="e388ddce-c79d-4db0-8a6f-cd69b1708954"
    ALZ_SUB_ID="4111975b-f6ca-4e08-b7b6-87d7b6c35840"

    # Reader at tenant root
    az role assignment create \
      --assignee $SP_OBJECT_ID \
      --role "Reader" \
      --scope "/providers/Microsoft.Management/managementGroups/$TENANT_ROOT_ID"

    # Contributor on identity subscription
    az role assignment create \
      --assignee $SP_OBJECT_ID \
      --role "Contributor" \
      --scope "/subscriptions/$IDENTITY_SUB_ID"

    # Reader on tfstate subscription
    az role assignment create \
      --assignee $SP_OBJECT_ID \
      --role "Reader" \
      --scope "/subscriptions/$TFSTATE_SUB_ID"

    # Storage Blob Data Contributor on tfstate storage
    az role assignment create \
      --assignee $SP_OBJECT_ID \
      --role "Storage Blob Data Contributor" \
      --scope "/subscriptions/$TFSTATE_SUB_ID/resourceGroups/rg-tfstate-co-dev-gwc-01/providers/Microsoft.Storage/storageAccounts/sttfstatecodevgwc01"

    # Reader on ALZ drives subscription
    az role assignment create \
      --assignee $SP_OBJECT_ID \
      --role "Reader" \
      --scope "/subscriptions/$ALZ_SUB_ID"
    ```
    **Note:** Step 5 (admin consent) requires Global Administrator or Privileged Role Administrator role. If CLI fails, grant via Portal:
    Azure AD → App registrations → sp-platform-identity-co-dev-na-01 → API permissions → Grant admin consent
