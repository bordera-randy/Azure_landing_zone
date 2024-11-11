locals {
    az_tenant_id                    = "76195987-c9c2-4822-8771-4c31d24951a5"
    az_subscription_id              = "a1c4dba0-b0eb-4923-8c56-061b0d014d56"
    mg_group_id                     = "b1c4dba0-b0eb-4923-8c56-061b0d014d56"
    managmentgroupname              = "DEMO-MG"
    infra_environment               = "dev"
    azure_location                  = "Central US"
    purpose                         = "Azure Landing Zone"
    owner                           = "Randy B"
    resource_group_name             = "uc-dev-common-rg"
    resource_group_hub_name         = "uc-dev-hub-rg"
    resource_group_automate_name    = "uc-dev-automate-rg"
    resource_vwan_name              = "uc-dev-hub-vwan"
    vhub_address_prefix             = "10.10.10.0/22"
    Audit_Public_Network_Access     = "/providers/Microsoft.Authorization/policySetDefinitions/f1535064-3294-48fa-94e2-6e83095a5c08"
    CIS_Benchmark_v2_0_0            = "/providers/Microsoft.Authorization/policySetDefinitions/06f19060-9e68-4070-92ca-f15cc126059e"
    HIPAA                           = "/providers/Microsoft.Authorization/policySetDefinitions/a169a624-5599-4385-a696-c8d643089fab"
    NIST_SP_800_53_v5               = "/providers/Microsoft.Authorization/policySetDefinitions/179d1daa-458f-4e47-8086-2a68d0d6c38f"
    
    # Additional variables
    tags = {
        infra_environment   = local.infra_environment
        owner               = local.owner
        purpose             = local.purpose
    }

    # Naming convention for resources
    naming_convention = {
        resource_group              = "${local.resource_group_name}-${local.azure_location}"
        storage_account_logs        = "ucdevdiag01strg"
        storage_account_automate    = "ucdevautomate01strg"
        key_vault_automate          = "ucdevautomate01kv"
        log_analytics_workspace     = "ucdevdiag01law"
    }
}

data "azurerm_subscription" "current" {}