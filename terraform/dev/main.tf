provider "aws" {
  region  = "ap-east-1"
  profile = "default"
}


module "key" {
  source      = "../modules/keypair"
  aws_keyname = var.aws_keyname
}

module "awsvpc" {
  source            = "../modules/awsvpc"
  awsvpcs           = var.awsvpcs
  awssubnet_public  = var.awssubnet_public
  awssubnet_private = var.awssubnet_private
  network_tag       = var.network_tag
}

/* module "awslb" {
  source = "../modules/awslb"
  lbtype = var.awslbtype
  aws_subnet_ids_depends_on = module.awsvpc.awsvpc_subnet_public_id
  network_tag =  var.network_tag
  depends_on = [
    module.awsvpc
  ]
} */