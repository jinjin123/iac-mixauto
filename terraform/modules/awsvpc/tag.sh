#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# Log stdin inputs to an output file so we only output the formatted
# JSON on stdout for the external data source to work correctly.
#  get input into logger
# cat - >> log.out
# Extract "foo" and "baz" arguments from the input into
# FOO and BAZ shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "VPC=\(.vpc_id) TABLE=\(.table_publicrt_id)"')"

# Placeholder for whatever data-fetching logic your script implements
VPC="$VPC"
TABLE="$TABLE"
# filter_query=`"Name=vpc-id,Values=${VPC}"`
# query_args = `"RouteTables[].Associations[?RouteTableId!='"${TABLE}"'].RouteTableId"`

private_rt_id=`aws ec2 describe-route-tables --filters "Name=vpc-id,Values='"${VPC}"'" --query   "RouteTables[].Associations[?RouteTableId!='"${TABLE}"'].RouteTableId" | jq -r .[][] `
# echo $private_rt_id >> log.txt
aws ec2 create-tags --resource $private_rt_id --tags Key="Name",Value="privateRouteTable"



# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
# jq -n --arg vpc "$VPC" '{"vpc":$vpc}' --arg table "$TABLE" '{"table":$table}'
jq -n --arg vpc_id "$VPC"  \
      --arg table_publicrt_id "$TABLE"  \
      '{"vpc":$vpc_id,"table":$table_publicrt_id}' 

