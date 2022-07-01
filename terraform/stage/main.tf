provider "aws" {
  region  = "ap-east-1"
  profile = "default"
}

/* data "external" "t" {
  program = ["bash", "${path.module}/tag.sh"]
  query = {
    "vpc_id"   = "vpc-0b728b80cf1082b8f",
    "table_publicrt_id" = "rtb-0a5910dc83a8593dd",
  }
}


output "test" {
  value = [data.external.t.result.table,data.external.t.result.vpc]
}
 */

resource "null_resource" "name" {

  provisioner "local-exec" {
    command = "echo $FOO $BAR $BAZ >> env_vars.txt"

    environment = {
      FOO = "bar"
      BAR = 1
      BAZ = "true"
    }


  }
}
