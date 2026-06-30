variable "ami_id" {
  description = "The ID of the Amazon Machine Image (AMI) to use for the EC2 instance."
  type        = string
  default     = "ami-0db56f446d44f2f09" 
}
variable "instance_type" {
  description = "The type of EC2 instance to create."
  type        = string
  default     = "t3a.small"
}
variable "ec2_instance_name" {
  description = "The name of the entry tracker EC2 instance."
  type        = string
  default     = "entryTracker-ec2-instance"
}
variable "availability_zone" {
  description = "The availability zone in which to deploy the EC2 instance."
  type        = string
  default     = "ap-south-1a"
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}
