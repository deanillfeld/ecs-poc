resource "aws_ecs_cluster" "main" {
  name = "tf-ecs-cluster"
}

resource "aws_ecs_task_definition" "main" {
  family                   = "nginxdemo"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  execution_role_arn = "arn:aws:iam::722141136946:role/ecs-poc-fargate-execution"

  container_definitions = <<EOF
[
  {
    "cpu": 256,
    "image": "722141136946.dkr.ecr.ap-southeast-2.amazonaws.com/app:v1",
    "memory": 512,
    "name": "nginxdemo",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOF
}

resource "aws_ecs_service" "main" {
  name            = "nginxdemo"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.app.id]
    subnets         = data.aws_subnet_ids.private.ids
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.id
    container_name   = "nginxdemo"
    container_port   = "80"
  }

  # depends_on = [
  #   aws_alb_listener.front_end
  # ]
}

resource "aws_security_group" "app" {
  name        = "nginxdemo"
  description = "nginx app demo"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
