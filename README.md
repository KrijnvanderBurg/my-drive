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

---

## Emergency Break-glass Account Setup

**CRITICAL:** Emergency accounts provide last-resort access when Conditional Access policies fail or misconfiguration locks out administrators.

### Manual Creation Process

1. **Create two cloud-only Global Administrator accounts:**
   ```bash
   # Via Azure Portal (not CLI/Terraform to keep credentials out of automation):
   # 1. Azure Portal → Entra ID → Users → New user
   # 2. User principal name: breakglass-01@<your-domain>.onmicrosoft.com
   # 3. Display name: Break-glass Account 01
   # 4. Password: Generate 20+ character random password
   # 5. Uncheck "Require this user to change password on first sign in"
   # 6. Repeat for breakglass-02@<your-domain>.onmicrosoft.com
   ```

2. **Assign Global Administrator role:**
   ```bash
   # Azure Portal → Entra ID → Roles and administrators → Global Administrator
   # Add both break-glass accounts as permanent assignments (not PIM eligible)
   ```

3. **Add accounts to break-glass exclusion group:**
   - Navigate to Entra ID → Groups
   - Find group: `sg-ca-exclude-breakglass-dev-na-01`
   - Add both `breakglass-01` and `breakglass-02` as members

4. **Store credentials securely:**
   - Print passwords and store in **physical safe** at office
   - Document safe location in security runbook (not in Git)
   - Alternative: Store in Azure Key Vault with restricted access
   - **Never** store in Terraform state or Git repositories

5. **Configure monitoring:**
   - Email alerts are automatically configured via Terraform
   - Ensure `krijnvdburg@protonmail.com` receives test alerts
   - Test alert delivery quarterly

### Testing Procedure

**Perform quarterly (every 3 months):**

1. Test one break-glass account sign-in
2. Verify Global Administrator access works
3. Confirm alert email is received within 5 minutes
4. Document test results in security log
5. Rotate passwords if breach suspected

### Password Requirements

- Minimum 20 characters
- Mix of uppercase, lowercase, numbers, special characters
- No dictionary words
- Unique (not reused elsewhere)
- Changed annually or on suspected compromise

---

## Conditional Access Policy Validation

Conditional Access policies are initially deployed in **report-only mode** to prevent accidental lockouts.

### Validation Process

1. **Monitor for 2 weeks in report-only mode:**
   ```bash
   # Check sign-in logs for policy evaluation
   # Azure Portal → Entra ID → Sign-in logs
   # Filter by: Conditional Access → Report-only
   ```

2. **Review impact:**
   - Verify no legitimate users would be blocked
   - Check for unexpected application/device combinations
   - Confirm break-glass accounts are properly excluded

3. **Enable policies one at a time:**
   ```bash
   # Edit 2_platform_identity/environments/dev/main.tf
   # Change state from "enabledForReportingButNotEnforced" to "enabled"
   # For one policy at a time, then apply:

   cd 2_platform_identity/environments/dev
   tofu plan
   tofu apply
   ```

4. **Recommended enablement order:**
   - **Week 1-2:** All policies in report-only mode
   - **Week 3:** Enable `CA001: Block legacy authentication`
   - **Week 4:** Enable `CA003: Require MFA for Azure management`
   - **Week 5:** Enable `CA002: Require MFA for all users`

5. **Monitor after each enablement:**
   - Watch for support tickets about access issues
   - Check sign-in failure rates
   - Be ready to disable policy if issues occur

### Rollback Procedure

If a policy causes issues:

```bash
# Immediately set policy to disabled in Terraform
# File: 2_platform_identity/environments/dev/main.tf
# Change: state = "disabled"

cd 2_platform_identity/environments/dev
tofu apply

# Investigate root cause
# Fix policy configuration
# Re-enable in report-only mode first
```

---
