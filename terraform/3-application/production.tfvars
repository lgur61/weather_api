remote_state_key    = "Production/platform.tfstate"
remote_state_bucket = "lg-terraform-state-bucket"


# Service Variables
ecs_service_name      = "nodejswebapp"
docker_container_port = 8080
desired_task_number   = "2"
web_app_profile       = "default"
memory                = 512
cpu                   = 256



# Fargate valid CPU and memory combinations

# CPU value       Memory value (MiB)
# 256 (.25 vCPU)  512 (0.5GB), 1024 (1GB), 2048 (2GB)
# 512 (.5 vCPU)   1024 (1GB), 2048 (2GB), 3072 (3GB), 4096 (4GB) 
# 1024 (1 vCPU)   2048 (2GB), 3072 (3GB), 4096 (4GB), 5120 (5GB), 6144 (6GB), 7168 (7GB), 8192 (8GB) 
# 2048 (2 vCPU)   Between 4096 (4GB) and 16384 (16GB) in increments of 1024 (1GB) 
# 4096 (4 vCPU)   Between 8192 (8GB) and 30720 (30GB) in increments of 1024 (1GB) 
