provider "azurerm" {
  features {}

  default_tags {
    tags = {
      project = "azure-terraform-secure-baseline"
      owner   = "alperen"
      env     = "dev"
    }
  }
}
