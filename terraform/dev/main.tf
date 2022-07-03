terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region =  "${var.aws_regions}"[0]
  /* region  = "ap-east-1" */
  /* profile = "default" */
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

/* module "awssecurity" {
  source = "../modules/awssecurity"
} */

/* module "awslb" {
  source = "../modules/awslb"
  lbtype = var.awslbtype
  aws_subnet_ids_depends_on = module.awsvpc.awsvpc_subnet_public_id
  aws_security_group_depends_on = module.awssecurity.aws_security
  network_tag =  var.network_tag
  depends_on = [
    module.awsvpc
    module.awssecurity
  ]
} */
/* module "awsec2" {
  source                        = "../modules/awsec2"
  aws_subnet_ids_depends_on     = module.awsvpc.awsvpc_subnet_public_id
  aws_security_group_depends_on = module.awssecurity.aws_security
  aws_amis                      = var.aws_amis["${var.aws_regions[10]}"]
  ec2_instance_type             = var.ec2_instance_type[0]
  aws_keyname                   = var.aws_keyname
  depends_on = [
    module.awsvpc,
    module.awssecurity
  ]
} */

/*  not support dynamic block pls see doc, desnt has block keyworld*/
/* module "awsebs" {
  source                     = "../modules/awsebs"
  awsec2_instance_depends_on = module.awsec2.awsec2_instance
  depends_on = [
    module.awsec2
  ]
} */
