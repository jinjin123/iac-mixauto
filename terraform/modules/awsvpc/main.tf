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
    Name = "public-subnet-${each.key}"
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
    Name = "${var.network_tag}-publicRouteTable"
  }
}

# Route table association with public subnets
//length  of map or list
resource "aws_route_table_association" "a" {
  count = length(values({for k,v in aws_subnet.public: k => v.id}))
  subnet_id =  "${element(values({for k,v in aws_subnet.public: k => v.id}),count.index)}"
  route_table_id = aws_route_table.public_rt.id
}

output "awsvpc_subnetid" {
  value = values({for k,v in aws_subnet.public: k => v.id})
}