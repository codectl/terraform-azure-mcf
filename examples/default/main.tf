module "naming" {
  source  = "codectl/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "prd"]
}

module "regions" {
  source  = "codectl/locations/azure"
  version = "~> 1.0"

  location = {
    primary = "westeurope"
  }
}

module "rg" {
  source  = "codectl/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = module.regions.location.primary.name
    }
  }
}

module "maintenance" {
  source  = "codectl/mcf/azure"
  version = "~> 1.0"

  maintenance = {
    name                     = module.naming.maintenance_configuration.name
    scope                    = "OSImage"
    resource_group_name      = module.rg.groups.demo.name
    location                 = module.rg.groups.demo.location
    in_guest_user_patch_mode = "User"
  }
}
