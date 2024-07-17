module "vpc" {
  source = "./vpc"
}

module "subnets" {
  source = "./subnets"
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source = "./rds"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.subnets.private_subnets
}

module "ecs_cluster" {
  source = "./ecs_cluster"
  vpc_id = module.vpc.vpc_id
}

module "ecs_service" {
  source               = "./ecs_service"
  cluster_id           = module.ecs_cluster.cluster_id
  vpc_id               = module.vpc.vpc_id
  public_subnets       = module.subnets.public_subnets
  container_name       = var.container_name
  container_image      = var.container_image
  container_port       = var.container_port
  task_execution_role_arn = module.iam.task_execution_role_arn
  task_role_arn        = module.iam.task_role_arn
}

module "iam" {
  source = "./iam"
}

module "acm" {
  source = "./acm"
  domain_name = "something.mydomain.com"
}

module "route53" {
  source      = "./route53"
  domain_name = "mydomain.com"
  alb_dns_name = module.alb.alb_dns_name
}

module "alb" {
  source            = "./alb"
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.subnets.public_subnets
  target_group_arn  = module.ecs_service.target_group_arn
  certificate_arn   = module.acm.certificate_arn
}