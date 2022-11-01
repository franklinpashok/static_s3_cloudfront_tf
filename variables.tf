#######################
# General settings
#######################

variable "standard_tags" {
  description = "Standard tags. If value is not applicable leave as empty or null."
  type = object({
    env         = string
    app_tier    = string
    appteam     = string
    cost_centre = string
    product     = string
    biz_dept    = string
  })

  validation {
    condition     = can(regex("^dev$|^qa$|^uat$|^prd$", var.standard_tags.env))
    error_message = "Err: invalid env, must be one of dev|qa|uat|prd."
  }

  validation {
    condition     = can(regex("^[1-3]", var.standard_tags.app_tier))
    error_message = "Err: invalid app tier, must be one 1|2|3."
  }

  validation {
    condition     = can(regex("\\d{4}", var.standard_tags.cost_centre))
    error_message = "Err: invalid cost-centre, must be 4 digits."
  }
}

variable "map_migrated" {
  description = "Map-migrated discount code"
  type        = string
  default     = "d-server-024yjdu5hnldqc"
}

##############################
### aws region and profile ###
##############################

variable "aws_region" {
  default     = "ap-southeast-1"
  type        = string
  description = "AWS region"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = ""
}

##################################
### VPC-Subnets-Securitygroups ###
##################################

#VPC ID
variable "vpcid" {
  description = "VPC id"
  default     = "default"
  type        = string
}

#db_subnet1
variable "db_subnet_a1" {
  description = "define subnet for DB"
  type        = string
  default     = ""
}

#db_subnet2
variable "db_subnet_a2" {
  description = "define subnet for DB"
  type        = string
  default     = ""
}
#db_subnet_b1
variable "db_subnet_b1" {
  description = "define subnet for DB"
  type        = string
  default     = ""
}

variable "db_subnet_b2" {
  description = "define subnet for DB"
  type        = string
  default     = ""
}

# App subnets
variable "app-subnet-a" {
  description = "define subnet for App"
  type        = string
  default     = ""
}
variable "app-subnet-b" {
  description = "define subnet for App"
  type        = string
  default     = ""
}

#Public subnets
variable "public-subnet-a" {
  description = "define public subnet "
  default     = ""
}
variable "public-subnet-b" {
  description = "define public subnet"
  type        = string
  default     = ""
}

#web subnets
variable "web-subnet-a" {
  description = "define public subnet "
  type        = string
  default     = ""
}
variable "web-subnet-b" {
  description = "define public subnet"
  type        = string
  default     = ""
}

#SG-Application
variable "Sg-webNapp" {
  description = "define security_groups"
  type        = string
  default     = ""
}

#SG-Application
variable "Sg-application" {
  description = "define security_groups"
  type        = string
  default     = ""
}

#SG-LBPublic
variable "Sg-lbpublic" {
  description = "define security_groups"
  type        = string
  default     = ""
}

#SG-LBPublic
variable "Sg-lbnm" {
  description = "define security_groups"
  type        = string
  default     = ""
}

variable "Sg-lbcorp" {
  description = "define security_groups"
  type        = string
  default     = ""
}


variable "Sg-db" {
  description = "define security_groups"
  type        = string
  default     = ""
}

###########
# S3 variables
###########

variable "s3_cors_rule" {
  description = "Map containing a rule of Cross-Origin Resource Sharing."
  type        = any # should be `map`, but it produces an error "all map elements must have the same type"
  default = {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "DELETE"]
    #allowed_origins = ["msdx-dev.sph.com.sg"]  #acm domain name, confirm
    allowed_origins = ["*.sph.com.sg"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

