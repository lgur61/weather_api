output "vpc_id" {
  value = data.terraform_remote_state.infrastructure.outputs.vpc_id
}

output "vpc_cidr_block" {
  value = data.terraform_remote_state.infrastructure.outputs.vpc_cidr_block
}

output "ecs_alb_listener_arn" {
  value = aws_alb_listener.ecs_alb_http_listener.arn
}

output "ecs_alb_dns_name" {
  value = aws_alb.ecs_cluster_alb.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.production-fargate-cluster.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.production-fargate-cluster.arn
}

output "ecs_cluster_role_name" {
  value = aws_iam_role.ecs_cluster_role.name
}

output "ecs_cluster_role_arn" {
  value = aws_iam_role.ecs_cluster_role.arn
}

output "ecs_domain_name" {
  value = var.ecs_domain_name
}

output "ecs_public_subnets" {
  value = data.terraform_remote_state.infrastructure.outputs.public_subnets
}

output "ecs_private_subnets" {
  value = data.terraform_remote_state.infrastructure.outputs.private_subnets
}

output "elasticache_hostname" {
  value = aws_elasticache_cluster.redis.cache_nodes.0.address
}

output "elasticache_port" {
  value = aws_elasticache_cluster.redis.cache_nodes.0.port
}

output "elasticache_endpoint" {
  value = "${aws_elasticache_cluster.redis.cache_nodes[0].address}:${aws_elasticache_cluster.redis.cache_nodes[0].port}"
}
