########################################################
##### S3 bucket policy for frontend static website #####
########################################################

module "s3_bucket" {
  source      = "./modules/msdwordpress/s3"
  bucket_name = "s3-dsgm-msd-frontend-dev"
  acl         = "public-read"
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = module.s3_bucket.bucket_name

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "docs" {
  bucket = module.s3_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}

####################################
##### Cloud Front Distribution #####
####################################
module "cdn" {
  source                        = "terraform-aws-modules/cloudfront/aws"
  comment                       = "Distribution for msddev static website"
  is_ipv6_enabled               = true
  price_class                   = "PriceClass_200"
  wait_for_deployment           = false
  create_origin_access_identity = true
  origin_access_identities = {
    msd-dev-static = module.s3_bucket.bucket_name
  }
  origin = {
    msd-dev-static = {
      domain_name = module.s3_bucket.s3_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "msd-dev-static"
        # key in `origin_access_identities`
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "msd-dev-static" # key in `origin` above
    viewer_protocol_policy = "redirect-to-https"

    default_ttl = 360
    min_ttl     = 300
    max_ttl     = 600

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = false

    function_association = {
      viewer-request = {
        function_arn = aws_cloudfront_function.viewer_request.arn
      }
    }
  }

  default_root_object = "index.html"
  custom_error_response = {
    error403 = {
      error_code         = 403
      response_code      = 404
      response_page_path = "/404.html"
    }
    error404 = {
      error_code         = 404
      response_code      = 404
      response_page_path = "/404.html"
    }
  }
}

resource "aws_cloudfront_function" "viewer_request" {
  name    = "msd-dev-cdn-viewer-request"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/templates/viewer-request.js")
}
