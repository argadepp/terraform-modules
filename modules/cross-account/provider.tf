terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider for Account A (Resource Owner)
provider "aws" {
  alias  = "account_a"
  region = "ap-south-1"
  profile = "account-a"  # Uses AWS CLI Profile
}

# AWS Provider for Account B (Requester)
provider "aws" {
  alias  = "account_b"
  region = "ap-south-1"
  profile = "account-b"  # Uses AWS CLI Profile
}
