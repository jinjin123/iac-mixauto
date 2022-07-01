variable "aws_keyname" {
  type = string
  default = "{}"
}
resource "tls_private_key" "key" {
  algorithm   = "RSA"
  ecdsa_curve = "P224"
}

resource "aws_key_pair" "public_key" {
  key_name   = var.aws_keyname
  public_key = tls_private_key.key.public_key_openssh
}
resource "local_file" "priavte_key" {
  content  = tls_private_key.key.private_key_pem
  filename =  var.aws_keyname
}

output "name" {
  value = aws_key_pair.public_key.key_name
}

// or  import exits keys 
/* resource "aws_key_pair" "terraform-demo" {
  key_name   = "terraform-demo"
  public_key = "${file("terraform-demo.pub")}"
}

resource "aws_instance" "import_example" {
  ami           = "${lookup(var.ami,var.aws_region)}"
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.terraform-demo.key_name}"
}

resource "aws_instance" "my-instance" {
  count         = "${var.instance_count}"
  ami           = "${lookup(var.ami,var.aws_region)}"
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.terraform-demo.key_name}"
  user_data     = "${file("install_apache.sh")}"

  tags = {
    Name  = "${element(var.instance_tags, count.index)}"
    Batch = "5AM"
  }
}

output "ip" {
  value = "${aws_instance.my-instance.*.public_ip}"
} */