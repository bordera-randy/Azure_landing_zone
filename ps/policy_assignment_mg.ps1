$resourcegroupname = 'rg-azps-01'
$az_tenant_id = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
$az_subscription_id = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
$policy_name = 'audit-vm-managed-disks'
$policy_id = '/providers/Microsoft.Authorization/policyDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
$mg_name = 'mg-azps-01'


Get-AzResourceProvider -ProviderNamespace 'Microsoft.PolicyInsights' |
   Select-Object -Property ResourceTypes, RegistrationState
Register-AzResourceProvider -ProviderNamespace 'Microsoft.PolicyInsights'

$rg = Get-AzResourceGroup -Name $resourcegroupname
$mg = Get-AzManagementGroup -GroupName $mg_name
$definition = Get-AzPolicyDefinition |
  Where-Object { $_.DisplayName -eq 'Audit VMs that do not use managed disks' }

$policyparms = @{
Name = 'audit-vm-managed-disks'
DisplayName = 'Audit VM managed disks'
Scope = $rg.ResourceId
PolicyDefinition = $definition
Description = 'Az PowerShell policy assignment to resource group'
}

New-AzPolicyAssignment @policyparms