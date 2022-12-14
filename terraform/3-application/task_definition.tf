resource "aws_ecs_task_definition" "web-app-task-definition" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  family                   = var.ecs_service_name
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.fargate_iam_role.arn
  task_role_arn            = aws_iam_role.fargate_iam_role.arn
  container_definitions = jsonencode([{
    name      = "${var.ecs_service_name}"
    image     = "${var.docker_image_url}"
    essential = true
    environment = [{
      name  = "web_app_profiles_active"
      value = "${var.web_app_profile}"
      },
      {
        name  = "REDIS_HOSTNAME",
        value = "${data.terraform_remote_state.platform.outputs.elasticache_hostname}"
      },
      {
        name  = "REDIS_PORT",
        value = data.terraform_remote_state.platform.outputs.elasticache_port
      }
    ]
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.docker_container_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "${var.ecs_service_name}-LogGroup"
        awslogs-region        = "${var.region}"
        awslogs-stream-prefix = "${var.ecs_service_name}-LogGroup-stream"
      }
    }

  }])
}


