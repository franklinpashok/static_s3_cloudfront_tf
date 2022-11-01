#########################
# EKS Cluster Networking
#########################
data "aws_vpc" "vpc" {
  id = var.vpcid
}

#########################
# EKS Cluster SUBNETS
#########################

#DB Subnets
data "aws_subnet" "db_subnet_a1" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.db_subnet_a1]
  }
}
data "aws_subnet" "db_subnet_a2" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.db_subnet_a2]
  }
}
data "aws_subnet" "db_subnet_b1" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.db_subnet_b1]
  }
}
data "aws_subnet" "db_subnet_b2" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.db_subnet_b2]
  }
}

#App subnets
data "aws_subnet" "app-subnet-a" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.app-subnet-a]
  }
}

data "aws_subnet" "app-subnet-b" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.app-subnet-b]
  }
}

# Public subnets
data "aws_subnet" "public-subnet-a" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.public-subnet-a]
  }
}
data "aws_subnet" "public-subnet-b" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.public-subnet-b]
  }
}

# web subnets
data "aws_subnet" "web-subnet-a" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.web-subnet-a]
  }
}
data "aws_subnet" "web-subnet-b" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.web-subnet-b]
  }
}

################################
## EKS Cluster Security group ##
################################

data "aws_security_group" "Sg-webNapp" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.Sg-webNapp]
  }
}

data "aws_security_group" "Sg-application" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.Sg-application]
  }
}

data "aws_security_group" "Sg-lbpublic" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.Sg-lbpublic]
  }
}

data "aws_security_group" "Sg-lbnm" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.Sg-lbnm]
  }
}

data "aws_security_group" "Sg-lbcorp" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.Sg-lbcorp]
  }
}

data "aws_security_group" "Sg-db" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:aws:cloudformation:logical-id"
    values = [var.Sg-db]
  }
}

########################################################
##### S3 bucket policy for frontend static website #####
########################################################

data "template_file" "bucket_policy" {
  template = fileexists("${path.module}/./modules/templates/s3_policy.tpl.json") ? file("${path.module}/./modules/templates/s3_policy.tpl.json") : ""

  vars = {
    bucket = "test-form-submission"
  }
}

##############
# IAM Role for lambda fucntion
#############

data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
