resource "aws_efs_file_system" "jenkins_efs" {
  creation_token = var.efs_name
  tags = {
    Name = var.efs_name
  }
}

# Mount Targets for EFS
resource "aws_efs_mount_target" "efs_mount_targets" {
  for_each       = toset(data.aws_subnets.subnets.ids)
  file_system_id = aws_efs_file_system.jenkins_efs.id
  subnet_id      = each.value
  security_groups = [aws_security_group.jenkins_sg.id]
}