
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow traffic to Jenkins instances"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Auto Scaling Launch Template
resource "aws_launch_template" "jenkins_lt" {
  name          = "jenkins-launch-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      volume_size           = 20
      delete_on_termination = true
      volume_type           = "gp3"
    }
  }

user_data = filebase64("./script.sh")


}




# Auto Scaling Group
resource "aws_autoscaling_group" "jenkins_asg" {
  desired_capacity     = var.des
  max_size             = var.max
  min_size             = var.min
  launch_template {
    id      = aws_launch_template.jenkins_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = data.aws_subnets.subnets.ids
}

# Load Balancer
resource "aws_lb" "jenkins_lb" {
  name               = "jenkins-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jenkins_sg.id]
  subnets            = data.aws_subnets.subnets.ids
}

resource "aws_lb_target_group" "jenkins_tg" {
  name     = "jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_lb_listener" "jenkins_listener" {
  load_balancer_arn = aws_lb.jenkins_lb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.jenkins_asg.name
  lb_target_group_arn    = aws_lb_target_group.jenkins_tg.arn
}
