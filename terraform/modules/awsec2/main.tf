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

variable "aws_subnet_ids_depends_on" {
  type    = any
  default = {}
}

locals {
  environment = terraform.workspace
}

/* separate count or one by one 
*/
/* module.awsvpc
{
  "awsvpc_subnet_merge_id" = [
    "subnet-0df81d59a1f72eef7",
    "subnet-0fe6ffa4ac354dfa9",
    "subnet-0421188b9d9a066bd",
  ]
  "awsvpc_subnet_private_id" = {
    "ap-east-1c" = "subnet-0421188b9d9a066bd"
  }
  "awsvpc_subnet_public_id" = {ec2_
    "ap-east-1a" = "subnet-0df81d59a1f72eef7"
    "ap-east-1b" = "subnet-0fe6ffa4ac354dfa9"
  }
  "vpc_public_rt" = tomap({
    "table_private_rt" = "rtb-09f860992bfc5bde7"
    "table_public_rt" = "rtb-0bf7a6184183d113c"
    "vpc" = "vpc-06c5064b6e2a63809"
  })
} */

resource "aws_instance" "name" {
  count             = 1
  subnet_id         = values(var.aws_subnet_ids_depends_on)["${count.index}"]
  security_groups   = ["${var.aws_security_group_depends_on}"]
  ami               = var.aws_amis
  instance_type     = var.ec2_instance_type
  key_name          = var.aws_keyname
  availability_zone = keys(var.aws_subnet_ids_depends_on)["${count.index}"]

  root_block_device {
    volume_size = 30
    volume_type = "standard"
    /* encrypted   = true
    kms_key_id  = data.aws_kms_key.customer_master_key.arn */
    tags = {
      Name = "${local.environment}-${var.ec2_tag}-${count.index}-volume"
    }
  }
  /* extend disk */
  /* 
      best way use this extend disk without ebs module...
   */
  /* ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    tags = {
      Name = "${terrform.workspace}-${var.ec2_tag}-${count.index}-ext-volume"
    }
  } */
      # Below is the ebs_block_device variable accepting a list of map. Each map contains a key-value pair.
    /* ebs_block_device = [
        {
            device_name = "/dev/sdf"
            volume_type = "gp2"
            volume_size = 5
            encrypted   = true
        },
        {
            device_name = "/dev/sdg"
            volume_type = "gp2"
            volume_size = 5
            encrypted   = true
        }
    ]
 */
  tags = {
    Name = "${local.environment}-${var.ec2_tag}-${count.index}"
  }
}
output "awsec2_instance" {
  value = aws_instance.name
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

