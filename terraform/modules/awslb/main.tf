variable "lbtype" {
  default = "application"
}
variable "network_tag" {
  default = "{}"
}

variable "aws_subnet_ids_depends_on" {
  type    = any
  default = {}
}

variable "aws_security_group_depends_on" {
  type = string
  default = "value"
}



resource "aws_lb" "name" {
  load_balancer_type = var.lbtype
  subnets = values(var.aws_subnet_ids_depends_on)
  /* security_groups = ["${var.aws_security_group_depends_on}"] */
  /* enable_deletion_protection  = true*/
  /* access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  } */

  tags = {
    Name = var.network_tag
  }
}

output "awslb" {
  value =  values(var.aws_subnet_ids_depends_on)
}


