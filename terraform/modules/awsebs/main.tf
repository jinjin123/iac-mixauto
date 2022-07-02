variable "ec2az" {
  type    = string
  default = "value"
}

variable "awsebs_size" {
  type    = number
  default = 1
}

variable "awsec2_instance_depends_on" {
  type    = list(any)
  default = []
}


/* only one by one attach, no other way , seems will create by zone array*/
resource "aws_ebs_volume" "name" {
  count             = length(var.awsec2_instance_depends_on[*]["availability_zone"])
  size              = var.awsebs_size
  availability_zone = element(var.awsec2_instance_depends_on[*]["availability_zone"], count.index)
  type              = "standard"
  tags = {
    Name = "test"
  }
}

output "awsext_ebs" {
  value = aws_ebs_volume.name
}

/*  attach by  manual*/