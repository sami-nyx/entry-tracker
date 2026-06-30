terraform{
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 3.0"
  }
}
}
provider "aws" {
  region = "ap-south-1"
}

module "entry_tracker" {
  source = "./entry-tracker-module"

  ec2_instance_name= "food_tracker_ec2_instance_xxxx"
}