
terraform {
  source = "../modules/jenkins-efs"

}

inputs = {
    region="ap-south-1"
    instance_type="t2.small"
    efs_name="jenkins-efs"
    des=2
    max=4
    min=1
}