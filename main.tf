//
// Deploy Datadog agent containers on AWS ECS Cluster
//

module "dd-agent" {
  source                                 = "git::https://github.com/devops-workflow/terraform-aws-ecs-service.git"
  name                                   = "${var.name}"
  environment                            = "${var.environment}"
  organization                           = "${var.organization}"
  docker_image                           = "datadog/agent:latest"
  ecs_cluster_arn                        = "${var.ecs_cluster_arn}"
  ecs_deployment_maximum_percent         = "100"
  ecs_deployment_minimum_healthy_percent = "30"
  ecs_desired_count                      = "${var.ecs_desired_count}"
  ecs_placement_strategy_field           = "instanceId"
  ecs_placement_strategy_type            = "spread"
  ecs_security_group_id                  = "${var.ecs_cluster_security_group_id}"
  enable_lb                              = false
  enabled                                = "${var.enabled}"
  region                                 = "${var.region}"
  vpc_id                                 = "${var.vpc_id}"

  ecs_placement_constraints = [{
    type = "distinctInstance"
  }]

  # Don't need - Make sure these are optional
  app_port       = 8125
  lb_subnet_ids  = ["${data.aws_subnet_ids.private_subnet_ids.ids}"]
  lb_enable_http = true
  lb_internal    = true

  docker_environment = "${list(
    map("name", "DD_API_KEY", "value", "${var.dd_api_key}"),
    map("name", "SD_BACKEND", "value", "docker"),
    map("name", "DD_TAGS",    "value", "clustername:${var.ecs_cluster_name} environment:one")
    )}"

  docker_mount_points = "${list(
    map("containerPath", "/var/run/docker.sock", "sourceVolume", "docker_sock"),
    map("containerPath", "/host/sys/fs/cgroup",  "sourceVolume", "cgroup", "readOnly", "true"),
    map("containerPath", "/host/proc",           "sourceVolume", "proc", "readOnly", "true")
    )}"

  docker_port_mappings = "${list(
    map("containerPort", 8125, "hostPort", 8125, "protocol", "udp")
    )}"

  docker_volumes = "${list(
    map("name", "docker_sock", "host_path", "/var/run/docker.sock"),
    map("name", "proc",        "host_path", "/proc/"),
    map("name", "cgroup",      "host_path", "/cgroup/")
    )}"

  container_definition_additional = "\"cpu\": 10"

  # Need service discovery or lb
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/common_use_cases.html
  # LB, Consul, CloudWatch/Lambda
}
