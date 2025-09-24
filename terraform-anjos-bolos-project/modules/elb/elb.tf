
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

resource "aws_lb" "alb_public" {
  name               = "alb-principal"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_security_group_id]

  subnets = [var.public_subnet_1a_id, var.public_subnet_1b_id]

  tags = {
    Name = "alb-principal"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb_public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2_1_attach" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = var.public_instance_1a_id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "ec2_2_attach" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = var.public_instance_1b_id
  port             = 8080
}

resource "aws_lb_target_group" "backend_tg" {
  name     = "backend-target-group-app"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path     = "/health"
    protocol = "HTTP"
    matcher  = "200"
    port     = "8080"
  }
}

resource "aws_lb" "alb_private" {
  name               = "alb-backend"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.private_security_group_id]

  subnets = [var.private_subnet_1a_id, var.private_subnet_1b_id]

  tags = {
    Name = "alb-backend"
  }
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.alb_private.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "backend_1_attach" {
  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id        = var.private_instance_1a_id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "backend_2_attach" {
  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id        = var.private_instance_1b_id
  port             = 8080
}
