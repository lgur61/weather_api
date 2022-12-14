resource "aws_elasticache_cluster" "redis" {
  cluster_id           = lower("${var.ecs_cluster_name}-redis")
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  port                 = 6379
  security_group_ids   = [aws_security_group.redis_security_group.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
}


resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.ecs_cluster_name}-redis-subnet-group"
  subnet_ids = concat(data.terraform_remote_state.infrastructure.outputs.public_subnets, data.terraform_remote_state.infrastructure.outputs.private_subnets)
}
