variable "awsvpcs" {
  default = "{}"
}

variable "awssubnet_public" {
  default = {}
}
// has area
variable "awssubnet_private" {
  default = {}
}
variable "network_tag" {
  default = "{}"
}

//one vpc with 2 public subnet and 1 private subnet
resource "aws_vpc" "name" {
  cidr_block           = var.awsvpcs
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = var.network_tag
  }
}
resource "aws_subnet" "public" {
  for_each          = var.awssubnet_public
  cidr_block        = each.value
  availability_zone = each.key
  vpc_id            = aws_vpc.name.id
  //default false , auto request dhcp
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${each.key}"
  }
}
resource "aws_subnet" "private" {
  for_each          = var.awssubnet_private
  cidr_block        = each.value
  availability_zone = each.key
  vpc_id            = aws_vpc.name.id
  tags = {
    Name = "private-subnet-${each.key}"
  }
}


resource "aws_internet_gateway" "name" {
  # One Internet Gateway per VPC
  /* for_each = aws_vpc.name */

  # each.value here is a full aws_vpc object
  /* vpc_id = each.value.id */
  vpc_id = aws_vpc.name.id
  tags = {
    Name = var.network_tag
  }
}
# Route table: attach Internet Gateway 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.name.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }
  tags = {
    Name = "publicRouteTable"
  }
}
# Route table: attach Internet Gateway 
# error error creating route: one of `carrier_gateway_id, core_network_arn, egress_only_gateway_id, gateway_id, instance_id, local_gateway_id, nat_gateway_id, network_interface_id, transit_gateway_id, vpc_endpoint_id, vpc_peering_connection_id` must be specified
/* resource "aws_route_table" "private_rt" {
  for_each = var.awssubnet_private
  vpc_id = aws_vpc.name.id
  route {
    cidr_block = each.value
  }
  tags = {
    Name = "privateRouteTable"
  }
} */

# route table association with public subnets
//length  of map or list
resource "aws_route_table_association" "a" {
  count          = length(values({ for k, v in aws_subnet.public : k => v.id }))
  subnet_id      = element(values({ for k, v in aws_subnet.public : k => v.id }), count.index)
  route_table_id = aws_route_table.public_rt.id
}
/* module "describe-route-tables" {
  count = 1
  source = "digitickets/cli/aws"
  role_session_name = "dev"
  aws_cli_commands = ["ec2", "describe-route-tables","--filters 'Name=vpc-id,Values=\"${aws_vpc.name.id}\"'"]
  aws_cli_query = "RouteTables[].Associations[?RouteTableId!=`\"${aws_route_table.public_rt.id}\"`].RouteTableId"
} */
data "external" "t" {
  program = ["sh", "${path.module}/tag.sh"]
  query = {
    "vpc_id"   = "${aws_vpc.name.id}",
    "table_publicrt_id" = "${aws_route_table.public_rt.id}"
  }
}


output "awsvpc_subnetid" {
  value = tolist([{ for k, v in aws_subnet.public : k => v.id }, { for k, v in aws_subnet.private : k => v.id }])
}
output "vpc_public_rt" {
  value = data.external.t.result
}
# route table association with private subnets
//length  of map or list
resource "aws_route_table_association" "private" {
  count = length(values({for k,v in aws_subnet.private: k => v.id}))
  subnet_id =  "${element(values({for k,v in aws_subnet.private: k => v.id}),count.index)}"
  route_table_id =  data.external.t.result.table_private_rt
}
