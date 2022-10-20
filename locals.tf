locals {

  standard_tags = merge(
    { for k, v in var.standard_tags : "sph:${replace(k, "_", "-")}" => try(join(":", v), v) if v != null && v != "" && length(v) != 0 },
    { map-migrated = var.map_migrated },
  )

  vpc_id = data.aws_vpc.vpc.id

  db_subnets = [
    data.aws_subnet.db_subnet_a1.id,
    data.aws_subnet.db_subnet_b1.id,
    data.aws_subnet.db_subnet_a2.id,
    data.aws_subnet.db_subnet_b2.id
  ]

  app_subnets = [
    data.aws_subnet.app-subnet-a.id,
    data.aws_subnet.app-subnet-b.id
  ]

  public_subnets = [
    data.aws_subnet.public-subnet-a.id,
    data.aws_subnet.public-subnet-b.id
  ]

  web_subnets = [
    data.aws_subnet.web-subnet-a.id,
    data.aws_subnet.web-subnet-b.id
  ]

  Sg-application = [data.aws_security_group.Sg-application.id]
  Sg-webNapp     = [data.aws_security_group.Sg-webNapp.id]
  Sg-lbpublic    = [data.aws_security_group.Sg-lbpublic.id]
  Sg-lbnm        = [data.aws_security_group.Sg-lbnm.id]
  Sg-lbcorp      = [data.aws_security_group.Sg-lbcorp.id]
  Sg-db          = [data.aws_security_group.Sg-db.id]
}
