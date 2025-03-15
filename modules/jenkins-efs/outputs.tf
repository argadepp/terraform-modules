output "vpcid" {
  value = data.aws_vpc.default.id
}

output "subnet_ids" {
  value = [for s in data.aws_subnet.subnets1 : s.cidr_block]
}