#!/usr/bin/env bash

# 1. Pull the JSON block from Secrets Manager natively on the EC2 instance
SECRETS_JSON=$(aws secretsmanager get-secret-value --secret-id demo/mysql/db_secrets --query SecretString --output text)

# 2. Extract passwords
export DB_PASSWORD=$(echo "$SECRETS_JSON" | jq -r '.DB_PASSWORD')
export DB_ROOT_PASSWORD=$(echo "$SECRETS_JSON" | jq -r '.DB_ROOT_PASSWORD')

# 3. Write them to a test file in the home directory

echo "DB_PASSWORD=$DB_PASSWORD" > /home/ec2-user/entry-tracker/.env
echo "DB_ROOT_PASSWORD=$DB_ROOT_PASSWORD" > /home/ec2-user/entry-tracker/.env

echo $(printenv | grep DB ) > /home/ec2-user/entry-tracker/testenv.vv