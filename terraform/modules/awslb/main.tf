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

resource "aws_lb" "name" {
  load_balancer_type = var.lbtype
  subnets = values(var.aws_subnet_ids_depends_on)

  tags = {
    Name = var.network_tag
  }
}

output "awslb" {
  value =  values(var.aws_subnet_ids_depends_on)
}


