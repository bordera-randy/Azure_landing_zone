provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg" {
    name     = "rg-landing-zone"
    location = "East US"
}

resource "azurerm_virtual_wan" "vwan" {
    name                = "vwan-landing-zone"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
}

resource "azurerm_virtual_hub" "vhub" {
    name                = "vhub-landing-zone"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    virtual_wan_id      = azurerm_virtual_wan.vwan.id
    address_prefix      = "10.0.0.0/16"
}

resource "azurerm_storage_account" "storage" {
    count                    = 2
    name                     = "storagelz${count.index}"
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_key_vault" "kv" {
    name                        = "kv-landing-zone"
    resource_group_name         = azurerm_resource_group.rg.name
    location                    = azurerm_resource_group.rg.location
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    sku_name                    = "standard"
    purge_protection_enabled    = true
    soft_delete_retention_days  = 90
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
    name                = "log-analytics-landing-zone"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    sku                 = "PerGB2018"
    retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "diag" {
    count               = 5
    name                = "diag-setting-${count.index}"
    target_resource_id  = element([azurerm_virtual_wan.vwan.id, azurerm_virtual_hub.vhub.id, azurerm_storage_account.storage[0].id, azurerm_storage_account.storage[1].id, azurerm_key_vault.kv.id], count.index)
    log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

    log_settings {
        category = "AllLogs"
        enabled  = true
    }

    metric_settings {
        category = "AllMetrics"
        enabled  = true
    }
}

resource "azurerm_policy_assignment" "caf_policies" {
    count               = 3
    name                = element(["policy1", "policy2", "policy3"], count.index)
    scope               = azurerm_resource_group.rg.id
    policy_definition_id = element(["/providers/Microsoft.Authorization/policyDefinitions/definition1", "/providers/Microsoft.Authorization/policyDefinitions/definition2", "/providers/Microsoft.Authorization/policyDefinitions/definition3"], count.index)
    description         = "CAF policy assignment for healthcare company"
    display_name        = "CAF Policy ${count.index + 1}"
}

resource "azurerm_policy_assignment" "hitrust_hipaa_policies" {
    name                = "hitrust-hipaa-policy"
    scope               = azurerm_resource_group.rg.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/HIPAAHITRUST"
    description         = "Policy assignment for HITRUST/HIPAA initiative"
    display_name        = "HITRUST/HIPAA Policy"
}
