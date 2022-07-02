variable "network_tag" {
  default = "{}"
}

variable "aws_security_group_depends_on" {
  type = string
  default = "value"
}

variable "awsvpc_merge_id_depends_on" {
  type = list
  default = []
}

variable "awsefs_create_token" {
  type = string
  default = "value"
}

resource "aws_efs_file_system" "nat" {
  creation_token = var.awsefs_create_token
  tags = {
    Name = var.network_tag
  }
}

output "efs_nat" {
  value = aws_efs_file_system.nat
}

resource "aws_efs_mount_target" "zone" {
  file_system_id  = aws_efs_file_system.nat.id
  count = length(var.awsvpc_merge_id_depends_on)
  subnet_id = element(var.awsvpc_merge_id_depends_on,count.index)
  security_groups = ["${var.aws_security_group_depends_on}"]
}

