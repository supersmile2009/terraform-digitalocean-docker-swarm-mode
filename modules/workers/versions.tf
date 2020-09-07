terraform {
  required_providers {
    cloudinit = {
      source = "hashicorp/cloudinit"
    }
    digitalocean = {
      source = "terraform-providers/digitalocean"
    }
  }
  required_version = ">= 0.13"
}
