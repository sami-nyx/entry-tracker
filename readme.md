TODO:
1. deploy the application to AWS EC2 instance using ssm
2. add documentation for the pipelie
3. add report generation for the pipeline
4. manage caching


# The AWS Workload Credentials Provider is a client-side HTTP service that,
# caches secrets in memory. Use it with Lambda, ECS, EKS, or EC2.  
# https://docs.aws.amazon.com/secretsmanager/latest/userguide/secrets-manager-agent.html

# Build the AWS Workload Credentials Provider
# Install AWS Workload Credentials Provider

# Retrieve secret 
# The example relies on the SSRF being present in a file, which is where it is stored by the install script.  
curl -v -H \
    "X-Aws-Parameters-Secrets-Token: $(</var/run/awssmatoken)" \
    'http://localhost:2773/secretsmanager/get?secretId=demo/mysql/db_secrets'

# Retrieve a specific version stage  
curl -H \
    "X-Aws-Parameters-Secrets-Token: $(</var/run/awssmatoken)" \
    'http://localhost:2773/secretsmanager/get?secretId=demo/mysql/db_secrets&versionStage=AWSCURRENT'
