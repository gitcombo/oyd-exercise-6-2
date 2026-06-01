# ─────────────────────────────────────────────
# Task 3 — ALB Security Group
# ─────────────────────────────────────────────
resource "aws_security_group" "alb" {
  name        = "mediastream-alb-sg"
  description = "Allow inbound traffic on the listener port and all outbound traffic for the ALB."
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "Allow HTTP traffic from anywhere on the listener port."
    from_port   = var.listener_port
    to_port     = var.listener_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "mediastream-alb-sg"
    Environment = var.environment
  }
}

# ─────────────────────────────────────────────
# Task 4 — Target Group
# ─────────────────────────────────────────────
resource "aws_lb_target_group" "api" {
  name        = "mediastream-api-tg"
  protocol    = "HTTP"
  port        = 80
  target_type = "instance"
  vpc_id      = data.aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "mediastream-api-tg"
    Environment = var.environment
  }
}

# ─────────────────────────────────────────────
# Task 5 — ALB, Listener, and Target Registration
# ─────────────────────────────────────────────
resource "aws_lb" "main" {
  name               = "mediastream-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.public.ids

  tags = {
    Name        = "mediastream-alb"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_lb_target_group_attachment" "api" {
  target_group_arn = aws_lb_target_group.api.arn
  target_id        = data.aws_instance.api.id
  port             = 80
}
