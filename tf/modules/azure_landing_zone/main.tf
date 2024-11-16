
# Create the Management Group
resource "azurerm_management_group" "root_mg" {
    display_name = local.managmentgroupname
    name         = local.managmentgroupname
    
}

resource "azurerm_management_group" "prd_mg" {
    display_name = "Production"
    name         = "${local.managmentgroupname}-prd" 
    parent_management_group_id = azurerm_management_group.root_mg.id
}

resource "azurerm_management_group" "poc_mg" {
    display_name = "Proof of Concept"
    name         = "${local.managmentgroupname}-poc" 
    parent_management_group_id = azurerm_management_group.root_mg.id
}

# Create Resource Groups
resource "azurerm_resource_group" "common_rg" {
    name     = local.resource_group_name
    location = local.azure_location
    tags     = local.tags
}

resource "azurerm_resource_group" "hub_rg" {
    name     = local.resource_group_hub_name
    location = local.azure_location
    tags     = local.tags
}
resource "azurerm_resource_group" "automate_rg" {
    name     = local.resource_group_name
    location = local.azure_location
    tags     = local.tags
}

# Create Virtual WAN and Virtual Hub
resource "azurerm_virtual_wan" "vwan" {
    name                = local.resource_vwan_name
    resource_group_name = azurerm_resource_group.hub_rg.name
    location            = local.azure_location
}

resource "azurerm_virtual_hub" "vhub" {
    name                = "vhub-landing-zone"
    resource_group_name = azurerm_resource_group.hub_rg.name
    location            = azurerm_resource_group.hub_rg.location
    virtual_wan_id      = azurerm_virtual_wan.vwan.id
    address_prefix      = local.vhub_address_prefix
}

# Create Storage Account, Key Vault, and Log Analytics Workspace
resource "azurerm_storage_account" "log_storage" {
    name                     = local.naming_convention.storage_account_logs
    resource_group_name      = azurerm_resource_group.common_rg.name
    location                 = azurerm_resource_group.common_rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_key_vault" "kv" {
    name                        = local.naming_convention.key_vault_automate
    resource_group_name         = azurerm_resource_group.automate_rg.name
    location                    = azurerm_resource_group.automate_rg.location
    tenant_id                   = local.az_tenant_id
    sku_name                    = "standard"
    purge_protection_enabled    = true
    soft_delete_retention_days  = 7
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
    name                = local.naming_convention.log_analytics_workspace
    resource_group_name = azurerm_resource_group.common_rg.name
    location            = azurerm_resource_group.common_rg.location
    sku                 = "PerGB2018"
    retention_in_days   = 30
    
}
