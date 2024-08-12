terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket               = "jeffcavejr-state-files"
    region               = "us-east-1"
    workspace_key_prefix = "env"
    key                  = "jeffcavejr-portfolio/terraform.tfstate"
  }
}
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      project = "jeffcavejr-portfolio"
    }
  }
}
