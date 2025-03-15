module "vpc2" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc-2"
  cidr = "192.168.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  public_subnets  = ["192.168.101.0/24", "192.168.102.0/24", "192.168.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "test"
  }

providers = {
    aws = aws.region2
  }

}