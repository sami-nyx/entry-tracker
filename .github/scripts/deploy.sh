#!/usr/bin/env bash

# 1. Pull the JSON block from Secrets Manager natively on the EC2 instance
SECRETS_JSON=$(aws secretsmanager get-secret-value --secret-id demo/mysql/db_secrets --query SecretString --output text)
mkdir -p /home/ec2-user/entry-tracker
cd /home/ec2-user/entry-tracker

# 1. Fetch fresh secrets from AWS Secrets Manager
SECRETS_JSON=$(aws secretsmanager get-secret-value --secret-id demo/mysql/db_secrets --query SecretString --output text)

# 2. OVERWRITE the file (using single >) with the static variables
cat << EOF > .env
DB_HOST=mysql-db
DB_PORT=3306
DB_USER=entry-tracker-app
DB_NAME=app_db
ECR_REGISTRY=${ECR_REGISTRY}
ECR_REPOSITORY=${ECR_REPOSITORY}
IMAGE_TAG=${IMAGE_TAG}
EOF

# 3. APPEND (using >>) only the secrets we just fetched
echo "DB_PASSWORD=$(echo "$SECRETS_JSON" | jq -r '.DB_PASSWORD')" >> .env
echo "DB_ROOT_PASSWORD=$(echo "$SECRETS_JSON" | jq -r '.DB_ROOT_PASSWORD')" >> .env

aws ecr get-login-password --region ap_south-1 | docker login --username AWS --password-stdin "${ECR_REGISTRY}"
# 4. Deploy
docker compose pull
docker compose up -d --no-build --remove-orphans