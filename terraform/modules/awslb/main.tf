variable "lbtype" {
    default = "application"
}
module "awssubnet" {
  source = "../awsvpc"
  subnets_ids = module.awssubnet.subnets_ids
}

resource "aws_lb" "name" {
  load_balancer_type = var.lbtype
  subnets = [var.subnets_ids]
}