


resource "aws_iam_role" "fargate_iam_role" {
  name = "${var.ecs_service_name}-IAM-Role"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
 {
   "Effect": "Allow",
   "Principal": {
     "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
   },
   "Action": "sts:AssumeRole"
  }
  ]
 }
EOF
}

resource "aws_iam_role_policy" "fargate_iam_policy" {
  name = "${var.ecs_service_name}-IAM-Role"
  role = aws_iam_role.fargate_iam_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "ecr:*",
        "logs:*",
        "cloudwatch:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.ecs_service_name}-service"
  task_definition = aws_ecs_task_definition.web-app-task-definition.arn
  desired_count   = var.desired_task_number
  cluster         = data.terraform_remote_state.platform.outputs.ecs_cluster_arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.terraform_remote_state.platform.outputs.ecs_public_subnets
    security_groups  = [aws_security_group.app_security_group.id]
    assign_public_ip = true
  }

  load_balancer {
    container_name   = var.ecs_service_name
    container_port   = var.docker_container_port
    target_group_arn = aws_alb_target_group.ecs_app_target_group.arn
  }
}

resource "aws_security_group" "app_security_group" {
  name        = "${var.ecs_service_name}-SG"
  description = "Security group for web app to communicate in and out"
  vpc_id      = data.terraform_remote_state.platform.outputs.vpc_id

  ingress {
    from_port   = 8080
    protocol    = "TCP"
    to_port     = 8080
    cidr_blocks = [data.terraform_remote_state.platform.outputs.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.ecs_service_name}-SG"
  }
}

resource "aws_alb_target_group" "ecs_app_target_group" {
  name        = "${var.ecs_service_name}-TG"
  port        = var.docker_container_port
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.platform.outputs.vpc_id
  target_type = "ip"

  health_check {
    path                = "/actuator/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "60"
    timeout             = "30"
    unhealthy_threshold = "3"
    healthy_threshold   = "3"
  }

  tags = {
    Name = "${var.ecs_service_name}-TG"
  }
}

resource "aws_alb_listener_rule" "ecs_alb_listener_rule" {
  listener_arn = data.terraform_remote_state.platform.outputs.ecs_alb_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_app_target_group.arn
  }

  condition {
    host_header {
      values = ["${lower(data.terraform_remote_state.platform.outputs.ecs_alb_dns_name)}"]
    }
  }
}

resource "aws_cloudwatch_log_group" "webapp_log_group" {
  name = "${var.ecs_service_name}-LogGroup"
}

