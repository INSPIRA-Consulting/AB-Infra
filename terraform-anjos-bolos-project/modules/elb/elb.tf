# Load Balancer para o Backend (Privado)
resource "aws_lb" "backend_lb" {
  name               = "ab-backend-lb"
  internal           = true
  load_balancer_type = "application"
  # security_groups    = [var.backend_security_group_id]
  subnets           = [var.private_subnet_1a_id, var.private_subnet_1b_id]

  tags = {
    Name = "Backend Load Balancer"
    Environment = "Production"
  }
}

# Target Group para o Backend
resource "aws_lb_target_group" "backend_tg" {
  name     = "ab-backend-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher            = "200"
    path               = "/health"
    port               = "traffic-port"
    protocol           = "HTTP"
    timeout            = 5
    unhealthy_threshold = 2
  }
}

# Attachment das instâncias backend ao target group
resource "aws_lb_target_group_attachment" "backend_tg_attachment" {
  count            = length(var.backend_instance_ids)
  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id        = var.backend_instance_ids[count.index]
  port             = 8080
}

# Listener para o Backend LB
resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}

# Load Balancer para o Database (Privado)
resource "aws_lb" "database_lb" {
  name               = "ab-database-lb"
  internal           = true
  load_balancer_type = "application"
  # security_groups    = [var.database_security_group_id]
  subnets           = [var.private_subnet_1a_id, var.private_subnet_1b_id]

  tags = {
    Name = "Database Load Balancer"
    Environment = "Production"
  }
}

# Target Group para o Database
resource "aws_lb_target_group" "database_tg" {
  name     = "ab-database-tg"
  port     = 3306
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    protocol           = "TCP"
    timeout            = 10
    unhealthy_threshold = 2
  }
}

# Attachment das instâncias de banco de dados ao target group
resource "aws_lb_target_group_attachment" "database_tg_attachment" {
  count            = length(var.database_instance_ids)
  target_group_arn = aws_lb_target_group.database_tg.arn
  target_id        = var.database_instance_ids[count.index]
  port             = 3306
}

# Listener para o Database LB
resource "aws_lb_listener" "database_listener" {
  load_balancer_arn = aws_lb.database_lb.arn
  port              = "3306"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.database_tg.arn
  }
}
