locals {
    infra_environments = ["dev", "test", "prod"]
    azure_location     = "East US"
    purpose            = "Azure Landing Zone"
    owner              = "Your Name"
    resource_group_name = "rg-landing-zone"

    # Additional variables
    tags = {
        environment = "dev"
        owner       = local.owner
        purpose     = local.purpose
    }

    # Naming convention for resources
    naming_convention = {
        resource_group = "${local.resource_group_name}-${local.azure_location}"
        storage_account = "st${local.resource_group_name}${local.azure_location}"
    }
}