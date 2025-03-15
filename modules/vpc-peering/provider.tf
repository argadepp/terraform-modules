# Define multiple providers for different AWS regions
provider "aws" {
  region = "eu-central-1"
  alias  = "region1"
}

provider "aws" {
  region = "ap-south-1"
  alias  = "region2"
}