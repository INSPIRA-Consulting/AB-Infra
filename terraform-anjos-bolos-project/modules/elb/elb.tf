
resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group-app"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path     = "/"
    protocol = "HTTP"
    matcher  = "200"
  }
}

resource "aws_lb" "alb-principal" {
  name               = "alb-principal"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_security_group_id]

  subnets = [var.public_instance_1a-id, var.public_instance_1b-id]

  tags = {
    Name = "alb-principal"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb-principal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2_1_attach" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = var.public_instance_1a-id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "ec2_2_attach" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = var.public_instance_1b-id
  port             = 8080
}

