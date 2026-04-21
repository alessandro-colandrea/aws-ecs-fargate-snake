module "network" {
  source = "./module/network"
  vpc_cidr = var.vpc_cidr
  subnet_priv = var.subnet_priv
  subnet_pubb = var.subnet_pubb
  subnet_pubb2=var.subnet_pubb2
  subnet_priv2 = var.subnet_priv2
}

module "compute" {
  source = "./module/compute"
  vpc_id = module.network.vpc_id
  subnet_privata_id = module.network.subnet_privata_id
  subnet_privata2_id = module.network.subnet_privata2_id
  container_image_url = "${module.ecr.repository_url}:latest"
  subnet_pubblica_id = module.network.subnet_pubblica_id
  alb_sg_id = module.load_balancer.alb_sg_id
  target_group_arn = module.load_balancer.target_group_arn
  depends_on = [module.load_balancer] 
}

module "ecr" {
  source = "./module/ecr"
}

module "auto_scaling" {
  source = "./module/auto_scaling"
  cluster_name = module.compute.cluster_name
  service_name = module.compute.service_name
}

module "load_balancer" {
  source       = "./module/load_balancer" 
  vpc_id       = module.network.vpc_id
  subnet_pubb  = module.network.subnet_pubblica_id
  subnet_pubb2 = module.network.subnet_pubblica2_id
}
