#!/bin/bash

sudo systemctl stop docker
sudo systemctl disable docker

sudo mv ~/.docker/{server-cert.pem,server-key.pem,ca.pem} /etc/docker/
sudo chmod 440 /etc/docker/{server-cert.pem,server-key.pem,ca.pem}
sudo chown root:docker /etc/docker/{server-cert.pem,server-key.pem,ca.pem}

sudo mkdir -p /etc/systemd/system/docker.service.d
sudo bash -c 'cat<<-EOF > /etc/systemd/system/docker.service.d/10-tls-verify.conf
[Service]
Environment="DOCKER_OPTS=--tlsverify=true --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server-cert.pem --tlskey=/etc/docker/server-key.pem"
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2376 -H unix://var/run/docker.sock --tlsverify=true --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server-cert.pem --tlskey=/etc/docker/server-key.pem
EOF'

sudo systemctl daemon-reload
sudo systemctl restart docker
