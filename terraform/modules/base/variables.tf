// multi cloud env variable 
// must define header
variable "aws_keyname" {
  type = string
  default = "test-mykey.pem"
}

variable "aws_amis" {
  type = map(string)
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-0d729a60"
  }
}

variable "aws_region" [
  "ap-east-1"
  "ap-east-1"
  "ap-east-1"
  "ap-east-1"
  "ap-east-1"
  "ap-east-1"
  "ap-east-1"
]

variable "aws_interfaces" {
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
}