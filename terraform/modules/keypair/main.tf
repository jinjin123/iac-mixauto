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