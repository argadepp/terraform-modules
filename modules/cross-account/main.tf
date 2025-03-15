
# IAM Role in Account A (Allows Account B to Assume It)
resource "aws_iam_role" "cross_account_role" {
  provider = aws.account_a  # Uses Account A

  name = "CrossAccountAccess"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::253490778720:root"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy in Account A (Allows EC2, VPC, S3 Access)
resource "aws_iam_policy" "cross_account_policy" {
  provider = aws.account_a  # Uses Account A

  name        = "CrossAccountAccessPolicy"
  description = "Allows Account B to access EC2, S3, and VPC in Account A"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeRouteTables",
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "cross_account_attach" {
  provider = aws.account_a  # Uses Account A

  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.cross_account_policy.arn
}


# IAM Role for EC2 to Assume Role in Account A
resource "aws_iam_role" "ec2_assume_role" {
  provider = aws.account_b
  name     = "EC2AssumeRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy to Allow EC2 to Assume Role in Account A
resource "aws_iam_policy" "assume_account_a_role" {
  provider = aws.account_b
  name     = "AssumeAccountARole"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = "arn:aws:iam::637423592422:role/CrossAccountAccess"
    }]
  })
}

# Attach the Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  provider   = aws.account_b
  role       = aws_iam_role.ec2_assume_role.name
  policy_arn = aws_iam_policy.assume_account_a_role.arn
}

# Create an Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  provider = aws.account_b
  name     = "EC2InstanceProfile"
  role     = aws_iam_role.ec2_assume_role.name
}

resource "aws_instance" "ec2_instance" {
  provider = aws.account_b
  ami             = data.aws_ami.amazon_linux_2.id # Change to your AMI ID
  instance_type   = "t3.micro"
  key_name = "cross-ac"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

}
