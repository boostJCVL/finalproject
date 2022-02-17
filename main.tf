module "vpc" {
    source = "./modules/vpc" #How to define where resources are referenced
    vpc_cidr = var.vpc_cidr

}
#terraform apply -var-file=./config/vars.tfvars
#terraform plan -var-file=./config/vars.tfvars 



module "autoscaling" {
    source = "./modules/autoscaling"
    vpc_id = module.vpc.vpc_id #How to reference assets from other modules
    priv_subnets = module.vpc.priv_subnets
    min = var.min
    max = var.max 
    desired = var.desired 
    autoscaleTG = module.loadbalancer.autoscaleTG
    ecs_role1 = module.ecs.ecs_role1
    clustername = module.ecs.clustername
    autoscaleTGG = module.loadbalancer.autoscaleTGG
}

module "loadbalancer" {
    source = "./modules/loadbalancer"
    vpc_id = module.vpc.vpc_id
    pub_subnets = module.vpc.pub_subnets
    security_group = module.autoscaling.security_group


}

module "ecs" {
    source = "./modules/ecs"
    autoscaleTG = module.loadbalancer.autoscaleTG
    security_group = module.autoscaling.security_group
    autoscaleTGG = module.loadbalancer.autoscaleTGG

}