resource "aws_alb" "main" {
  name            = "nginxdemo"
  subnets         = data.aws_subnet_ids.public.ids
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "main" {
  name        = "nginxdemo"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected.id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_security_group" "lb" {
  name        = "nginxdemo-lb"
  description = "nginx app demo"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 80
    to_port     = 80
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
