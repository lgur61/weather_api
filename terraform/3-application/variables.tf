variable "region" {
  default = "us-east-1"
}

variable "remote_state_key" {}
variable "remote_state_bucket" {}
variable "ecs_service_name" {}
variable "docker_image_url" {}
variable "memory" {}
variable "cpu" {}
variable "docker_container_port" {}
variable "web_app_profile" {}
variable "desired_task_number" {}