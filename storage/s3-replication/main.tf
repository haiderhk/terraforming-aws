terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket  = "acme-terraform-state-bucket-v1"
    key = "storage/s3-replication/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true

  }
}


# Two providers, Two regions for CRR
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias = "replication-region"
  region = "eu-central-1"
}
