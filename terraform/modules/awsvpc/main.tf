//one vpc with 2 public subnet and 1 private subnet
resource "aws_vpc" "name" {
  /* for_each =  var.awsvpcs
  cidr_block = each.value.cidr_block */
  cidr_block = var.awsvpcs
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
      Name = var.tags
  }
}
resource "aws_subnet" "public" {
  for_each =  var.awssubnet_public
  cidr_block = each.value.cidr_block.value
  availability_zone = each.key
  vpc_id = aws_vpc.name.id
  //default false , auto request dhcp
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${each.key}"
  }
}
resource "aws_subnet" "private" {
  for_each =  var.awssubnet_private
  cidr_block = each.value.cidr_block.value
  availability_zone = each.key
  vpc_id = aws_vpc.name.id
}


resource "aws_internet_gateway" "name" {
  # One Internet Gateway per VPC
  /* for_each = aws_vpc.name */

  # each.value here is a full aws_vpc object
  /* vpc_id = each.value.id */
  vpc_id =  aws_vpc.name.id
  tags = {
    Name = var.tags
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

# Route table association with public subnets
//length  of map or list
resource "aws_route_table_association" "a" {
  count = length(var.awssubnet_public)
  subnet_id      = element(aws_subnet.public.*.id,count.index)
  route_table_id = aws_route_table.public_rt.id
}

output "vpc_ids" {
  value = {
    for k, v in aws_vpc.name : k => v.id
  }

  # The VPCs aren't fully functional until their
  # internet gateways are running.
  depends_on = [aws_internet_gateway.name]
}