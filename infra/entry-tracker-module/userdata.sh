#!/bin/bash
# userdata.sh
dnf update -y || yum update -y

# 1. Install prerequisites
dnf install -y dnf-plugins-core || yum install -y yum-utils

# 2. Add the official Docker-CE repository (bypasses the buggy Amazon build)
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo || \
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sed -i 's/\$releasever/9/g' /etc/yum.repos.d/docker-ce.repo
# 3. Install official Docker Engine packages
dnf install -y docker-ce docker-ce-cli containerd.io || \
yum install -y docker-ce docker-ce-cli containerd.io

# 4. Start and enable Docker
systemctl start docker
systemctl enable docker

# 5. Add user permissions
usermod -aG docker ec2-user

# 6. Install Docker Compose standalone binary
DOCKER_COMPOSE_VERSION="v2.27.1"
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# 7. Enable the 'docker compose' (dash-less) CLI plugin syntax correctly
mkdir -p /usr/libexec/docker/cli-plugins
ln -sf /usr/local/bin/docker-compose /usr/libexec/docker/cli-plugins/compose