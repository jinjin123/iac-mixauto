variable "aws_security_group_depends_on" {
  type    = string
  default = "value"
}
variable "aws_amis" {
  type    = string
  default = "value"
}

variable "ec2_instance_type" {
  type    = string
  default = "value"
}

variable "aws_keyname" {
  type    = string
  default = "value"
}

variable "ec2_tag" {
  type    = string
  default = "value"
}

variable "private_key" {
  type    = string
  default = "value"
}

variable "aws_efs_id_depends_on" {
  type    = string
  default = "value"
}

/* separate count or not */
resource "aws_instance" "name" {
  count           = 1
  security_groups = ["${var.aws_security_group_depends_on}"]
  ami             = var.aws_amis
  instance_type   = var.ec2_instance_type
  key_name        = var.aws_keyname

  tags = {
    Name = "${terrform.workspace}-${var.ec2_tag}-${count.index}"
  }
}

/* install package  */
/* resource "null_resource" "cluster" {
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = var.private_key
    #private_key = file("${path.module}/private_key.pem")
    host     = aws_instance.name.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install git httpd php  -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo yum install amazon-efs-utils nfs-utils -y",
      "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${var.aws_efs_id_depends_on.nat.id}.efs.ap-south-1.amazonaws.com:/ /var/www/html",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/rohitraut3366/mulicloud.git /var/www/html"
    ]
  }
}


resource "null_resource" "cluster3" {
    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = var.private_key
    #private_key = file("${path.module}/private_key.pem")
    host     = aws_instance.name.public_ip
  }
  provisioner "remote-exec" {
    inline = [
          "sudo yum install amazon-efs-utils nfs-utils -y",
          "sudo mkdir /efs",
          "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${var.aws_efs_id_depends_on.nat.id}.efs.ap-south-1.amazonaws.com:/ /efs",
        ]
    }
} */
output "e" {
  value = aws_efs_file_system.nat.id
}
