standard_tags = {
  env         = "dev"
  app_tier    = "2"
  appteam     = "pheonix"
  cost_centre = "1111"
  product     = "staticwebsite"
  biz_dept    = "pheonix-test"
}

aws_region  = "ap-southeast-1"
aws_profile = "default"
#aws_profile = "sandbox-testwordpress"

#VPC
#vpcid = ""
#sandboxVPC
vpcid = "vpc-0838d2a8456b987e4"

#SUBNET-ID
db_subnet_a1    = "dbSubnetA1"
db_subnet_a2    = "dbSubnetA2"
db_subnet_b1    = "dbSubnetB1"
db_subnet_b2    = "dbSubnetB2"
app-subnet-a    = "appSubnetA"
app-subnet-b    = "appSubnetB"
public-subnet-a = "publicSubnetA"
public-subnet-b = "publicSubnetB"
web-subnet-a    = "webSubnetA"
web-subnet-b    = "webSubnetB"

#Security Groups
Sg-application = "securityGroupApplication"
Sg-webNapp     = "securityGroupWebNApp"
Sg-lbpublic    = "securityGroupLBPublic"
Sg-lbnm        = "securityGroupLBNM"
Sg-lbcorp      = "securityGroupLBCorp"
Sg-db          = "securityGroupDB"

#Common Tags
Name = "eks-selfmanaged-imduat"
# env          = "imd-uat"
# cost_centre  = "1380"
# owner        = "devops"
# map-migrated = "d-server-024yjdu5hnldqc"
# product      = "IMSPH Website"

#For spot instances
default_instance_market_options = { market_type = "spot" }
