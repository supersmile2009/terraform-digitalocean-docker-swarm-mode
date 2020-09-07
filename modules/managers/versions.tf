terraform {
  required_providers {
    cloudinit = {
      source = "hashicorp/cloudinit"
    }
    digitalocean = {
      source = "terraform-providers/digitalocean"
    }
    external = {
      source = "hashicorp/external"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}
