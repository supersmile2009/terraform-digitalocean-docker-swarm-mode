data "cloudinit_config" "config" {
  gzip = false
  base64_encode = false

  dynamic "part" {
    for_each = var.extra_cloudinit_config != "" ? [true] : []
    content {
      content_type = "text/cloud-config"
      content = var.extra_cloudinit_config
    }
  }
  part {
    content_type = "text/cloud-config"
    content = file("${path.module}/scripts/cloud-config.yaml")
  }
}

resource "digitalocean_droplet" "worker" {
  count = var.total_instances
  image = var.image
  name = format(
    "%s-%02d.%s.%s",
    var.name,
    count.index + 1,
    var.region,
    var.domain,
  )
  size               = var.size
  private_networking = true
  region             = var.region
  ssh_keys           = var.ssh_keys
  user_data          = data.cloudinit_config.config.rendered
  tags               = var.tags

  connection {
    type    = "ssh"
    user    = "dev"
    host    = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token ${var.join_token} ${var.manager_private_ip}",
    ]
  }

  provisioner "remote-exec" {
    when = destroy

    inline = [
      "timeout 25 docker swarm leave --force",
    ]

    on_failure = continue
  }
}
