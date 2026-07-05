#====================================================sg===========================================
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # "-1" means ALL protocols (TCP, UDP, ICMP, etc.)
    cidr_blocks = ["0.0.0.0/0"] # Allows outbound traffic to anywhere
  }
}
#====================================================IAM-ecr-pull-policy===========================================
resource "aws_iam_policy" "ecr_pull_policy" {
  name = "ecr-pull-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}
#====================================================Acess-secrets-policy===========================================
resource "aws_iam_policy" "access_secrets_policy" {
  name = "access-secrets-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement= [
        {
            "Sid": "AllowReadEntryTrackerSecrets",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret"
            ],
            "Resource": "arn:aws:secretsmanager:ap-south-1:889867978066:secret:demo/mysql/db_secrets-NZUocs"
        }
    ]})
    }
#====================================================ssm-core-policy===========================================
# resource "aws_iam_policy" "ssm_core_policy" {
#   name = "ssm-core-policy"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [ 
#       #fill this
#     ]
#   })
# }
# =====================================================IAM-role===========================================
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  
}

#=====================================================IAM-role-policy-attachment===========================================
resource "aws_iam_role_policy_attachment" "attach_ecr_pull_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
}
resource "aws_iam_role_policy_attachment" "attach_ssm_core_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

resource "aws_iam_role_policy_attachment" "attach_access_secrets_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.access_secrets_policy.arn

}
#=====================================================IAM-instance-profile===========================================

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}
