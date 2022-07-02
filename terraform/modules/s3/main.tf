variable "awss3_acl" {
  type = string
  default = "value"
}

variable "network_tag" {
  type = string
  default = "value"
}

variable "awss3_bucket_name" {
  type = string
  default = "value"
}

resource "aws_s3_bucket" "name" {
  bucket = var.awss3_bucket_name
  acl = var.awss3_acl
  tags = {
    Name = var.awss3_bucket_name
  }
  /* return id arn bucket_domain */
}
/*  upload  */
/* resource "aws_s3_bucket_object" "name" {
  key = "Img.png"
  bucket = aws_s3_bucket.name.id
  source = "abc.png"
  acl = "public-read"
} */

output "awss3_bucket" {
  value =  {"s3id": aws_s3_bucket.name.id, "s3arn":aws_s3_bucket.name.arn}
}