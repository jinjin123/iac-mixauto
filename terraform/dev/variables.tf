// multi cloud env variable 
// must define header
variable "aws_keyname" {
  type = string
  default = "test-key.pem"
}
//not area
variable "awsvpcs" {
    /* type = map(object({
      cidr_block = string
    }))
    default = {
      "a"="172.31.0.0/16",
      "b"="10.0.0.0/16"
    } */
    type = string
    default = "10.0.0.0/16"

}
// has area
variable "awssubnet_public" {
    /* type = map(object({
      ap-east-1a=string,
      ap-east-1b=string,
    })) */
    type=map(string)
    default = {
          ap-east-1a="10.0.1.0/24",
          ap-east-1b="10.0.2.0/24",
    }
    /* default = {
      ap-east-1a{ap-east-1a="10.0.1.0/20"},
      ap-east-1b="10.0.2.0/20",
    } */
}
// has area
variable "awssubnet_private" {
    /* type = map(object({
      ap-east-1c=string,
    })) */
    type=map(string)
    default = {
        ap-east-1c="10.0.3.0/24",
    }
}

variable "network_tag" {
  default = "dev-net"
}
variable "aws_amis" {
  type = map
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-0d729a60"
  }
}


variable "aws_regions" {
  type = list(string)
  default = [
    "eu-north-1",
    "ap-south-1",
    "eu-west-3",
    "eu-west-2",
    "eu-west-1",
    "ap-northeast-3",
    "ap-northeast-2",
    "ap-northeast-1",
    "sa-east-1",
    "ca-central-1",
    "ap-east-1",
    "ap-southeast-1",
    "ap-southeast-2",
    "eu-central-1",
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2"
  ]
}
/* variable "aws_interfaces" {
  description = <<-EOF
  List of the network interface specifications.
  The first should be the Management network interface, which does not participate in data filtering.
  The remaining ones are the dataplane interfaces.
  - `name`: (Required|string) Name tag for the ENI.
  - `description`: (Optional|string) A descriptive name for the ENI.
  - `subnet_id`: (Required|string) Subnet ID to create the ENI in.
  - `private_ip_address`: (Optional|string) Private IP to assign to the ENI. If not set, dynamic allocation is used.
  - `eip_allocation_id`: (Optional|string) Associate an existing EIP to the ENI.
  - `create_public_ip`: (Optional|bool) Whether to create a public IP for the ENI. Default false.
  - `public_ipv4_pool`: (Optional|string) EC2 IPv4 address pool identifier. 
  - `source_dest_check`: (Optional|bool) Whether to enable source destination checking for the ENI. Default false.
  - `security_groups`: (Optional|list) A list of Security Group IDs to assign to this interface. Default null.
  Example:
  ```
  interfaces =[
    {
      name: "mgmt"
      subnet_id: subnet-00000000000000001
      create_public_ip: true
    },
    {
      name: "public"
      subnet_id: subnet-00000000000000002
      create_public_ip: true
      source_dest_check: false
    },
    {
      name: "private"
      subnet_id: subnet-00000000000000003
      source_dest_check: false
    },
  ]
  ```
  EOF
} */

variable "tags" {
  description = "A map of tags to be associated with the resources created."
  default     = {}
  /* type        = map(any) */
}