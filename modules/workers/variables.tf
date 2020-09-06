variable "domain" {
  description = "Domain name used in droplet hostnames, e.g example.com"
}

variable "join_token" {
  description = "Join token for the nodes"
}

variable "manager_private_ip" {
  description = "Ip adress of a manager node, used to have a node join the existing cluster"
}

variable "ssh_keys" {
  type        = list(number)
  description = "A list of SSH IDs or fingerprints to enable in the format [12345, 123456] that are added to worker nodes"
}

variable "region" {
  description = "Datacenter region in which the cluster will be created"
  default     = "ams3"
}

variable "total_instances" {
  description = "Total number of workers in a cluster"
  default     = 1
}

variable "image" {
  description = "Droplet image used for the manager nodes"
  default     = "ubuntu-20-04-x64"
}

variable "size" {
  description = "Droplet size of manager nodes"
  default     = "s-1vcpu-1gb"
}

variable "name" {
  description = "Prefix for name of manager nodes"
  default     = "manager"
}

variable "tags" {
  description = "List of DigitalOcean tag ids"
  default     = []
  type        = list(string)
}

variable "user" {
  description = "Username to ssh into the server"
}

variable "extra_cloudinit_config" {
  description = "Cloud-init config to run on server setup"
}
