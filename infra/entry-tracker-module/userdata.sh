#!/bin/bash
# userdata.sh
dnf update -y || yum update -y

# 2. Install Docker
dnf install -y docker || yum install -y docker

# 3. Start Docker service and enable it to run on boot
systemctl start docker
systemctl enable docker

# 4. Add the default 'ec2-user' to the docker group 
# This lets you run 'docker' commands without typing 'sudo'
usermod -aG docker ec2-user

# 5. Download and install Docker Compose v2 (Latest stable)
# We fetch the binary directly from GitHub and place it in the system binaries
DOCKER_COMPOSE_VERSION="v2.27.1"
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 6. Make the Docker Compose binary executable
chmod +x /usr/local/bin/docker-compose

# 7. Create a symlink so it's accessible globally via 'docker-compose'
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
# 1. Create the system CLI plugins directory if it doesn't exist
mkdir -p /usr/libexec/docker/cli-plugins

# 2. Link your existing compose binary into that directory as 'docker-compose'
ln -s /usr/local/bin/docker-compose /usr/libexec/docker/cli-plugins/docker-compose

# Writing to /etc/profile.d/ ensures these load for both SSM sessions and ec2-user
cat << 'EOF' > /etc/profile.d/app_env.sh
export DB_HOST="mysql-db"
export DB_PORT="3306"
export DB_USER="entry-tracker-app"
export DB_NAME="app_db"
EOF

# Set permissions so any shell runner can read the environment variables
chmod +x /etc/profile.d/app_env.sh