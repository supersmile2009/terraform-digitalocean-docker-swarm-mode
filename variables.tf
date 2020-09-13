variable "domain" {
  description = "Domain name used in droplet hostnames, e.g example.com"
}

variable "ssh_keys" {
  type        = list(number)
  description = "A list of SSH IDs or fingerprints to enable in the format [12345, 123456] that are added to the provisioned nodes"
}

variable "provision_user" {
  default     = "root"
  description = "User used to log in to the droplets via ssh for running provisioning commands"
}

variable "region" {
  description = "Datacenter region in which the cluster will be created"
  default     = "nyc3"
}

variable "total_managers" {
  description = "Total number of managers in cluster"
  default     = 1
}

variable "total_workers" {
  description = "Total number of workers in cluster"
  default     = 1
}

variable "manager_image" {
  description = "Image for the manager nodes"
  default     = "coreos-alpha"
}

variable "worker_image" {
  description = "Droplet image for the worker nodes"
  default     = "coreos-alpha"
}

variable "manager_size" {
  description = "Droplet size of worker nodes"
  default     = "s-1vcpu-1gb"
}

variable "worker_size" {
  description = "Droplet size of worker nodes"
  default     = "s-1vcpu-1gb"
}

variable "manager_name" {
  description = "Prefix for name of manager nodes"
  default     = "manager"
}

variable "worker_name" {
  description = "Prefix for name of worker nodes"
  default     = "worker"
}

variable "manager_tags" {
  description = "List of DigitalOcean tag ids"
  default     = []
  type        = list(string)
}

variable "worker_tags" {
  description = "List of DigitalOcean tag ids"
  default     = []
  type        = list(string)
}

variable "remote_api_ca" {
  description = "CA file contents for the docker remote API"
}

variable "remote_api_certificate" {
  description = "Certificate file contents for the docker remote API"
}

variable "remote_api_key" {
  description = "Private key file contents for the docker remote API"
}

variable "cloud_init_config" {
  description = "Cloud init config to run on server setup"
  type = string
}
