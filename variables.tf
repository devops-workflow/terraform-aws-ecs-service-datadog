variable "dd_api_key" {
  description = "Datadog API Key"
}

variable "ecs_cluster_arn" {
  description = "ECS Cluster ARN"
}

variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
}

variable "ecs_cluster_security_group_id" {
  description = "ECS Cluster security group ID"
}

variable "ecs_desired_count" {
  description = "Number of Datadog agents to deploy. This should match the size of the ECS cluster"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating anything"
  default     = true
}

variable "environment" {
  description = "Environment name"
}

variable "name" {
  description = "ECS service name"
  default     = "datadog"
}

variable "organization" {
  description = "Organization name"
}

variable "region" {
  description = "AWS region to deploy in"
}

variable "vpc_id" {
  description = "ID of VPC to deploy in"
}
