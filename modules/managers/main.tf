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

resource "digitalocean_droplet" "manager" {
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
      "mkdir -p ~/.docker",
    ]
  }

  provisioner "file" {
    content      = var.remote_api_ca
    destination = "~/.docker/ca.pem"
  }

  provisioner "file" {
    content      = var.remote_api_certificate
    destination = "~/.docker/server-cert.pem"
  }

  provisioner "file" {
    content      = var.remote_api_key
    destination = "~/.docker/server-key.pem"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/install-certificates.sh"
    destination = "~/.docker/install-certificates.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/.docker/install-certificates.sh",
      "~/.docker/install-certificates.sh",
      "rm ~/.docker/install-certificates.sh",
      count.index == 0 ? "docker swarm init --advertise-addr ${self.ipv4_address_private} &>/dev/null" : "true",
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

data "external" "swarm_tokens" {
  program    = ["bash", "${path.module}/scripts/get-swarm-join-tokens.sh"]
  depends_on = [digitalocean_droplet.manager]

  query = {
    host = element(digitalocean_droplet.manager.*.ipv4_address, 0)
    user = "dev"
  }
}

resource "null_resource" "join" {
  count = var.total_instances - 1

  connection {
    host = element(digitalocean_droplet.manager.*.ipv4_address, count.index + 1)
    type = "ssh"
    user = "dev"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token ${data.external.swarm_tokens.result["manager"]} ${digitalocean_droplet.manager[0].ipv4_address_private}",
    ]
  }
}
