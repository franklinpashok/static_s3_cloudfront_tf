resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = var.acl
  #checkov:skip=CKV_AWS_144:The bucket dont have cross region replication
  #checkov:skip=CKV_AWS_18:Ensure the S3 bucket has access logging enabled
  #checkov:skip=CKV_AWS_145:Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_19:Ensure all data stored in the S3 bucket is securely encrypted at rest
  dynamic "server_side_encryption_configuration" {
    for_each = length(var.server_side_encryption_configuration) != 0 ? [var.server_side_encryption_configuration] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = lookup(server_side_encryption_configuration.value, "kms_master_key_id", "")
          sse_algorithm     = lookup(server_side_encryption_configuration.value, "sse_algorithm", "AES256")
        }
      }
    }
  }
  dynamic "cors_rule" {
    for_each = length(keys(var.cors_rule)) == 0 ? [] : [var.cors_rule]

    content {
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_transition_rule_enabled ? [""] : []
    content {
      id      = format("Transition objects after %d days", var.current_version_transition_days)
      enabled = var.lifecycle_transition_rule_enabled

      dynamic "transition" {
        for_each = var.current_version_transition_days > 0 ? [""] : []
        content {
          days          = var.current_version_transition_days
          storage_class = var.current_version_transition_class
        }
      }

      dynamic "expiration" {
        for_each = var.expired_object_permanent_deletion_days > 0 ? [""] : []
        content {
          days = var.expired_object_permanent_deletion_days
        }
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule_enabled ? [""] : []
    content {
      id      = format("Expire previous versions of objects after %d days", var.noncurrent_version_expiration_days)
      enabled = var.lifecycle_rule_enabled

      dynamic "noncurrent_version_expiration" {
        for_each = var.noncurrent_version_expiration_days > 0 ? [""] : []
        content {
          days = var.noncurrent_version_expiration_days
        }
      }

      dynamic "expiration" {
        for_each = var.expired_object_delete_marker ? [""] : []
        content {
          expired_object_delete_marker = var.expired_object_delete_marker
        }
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule

    content {
      id                                     = lookup(lifecycle_rule.value, "id", null)
      prefix                                 = lookup(lifecycle_rule.value, "prefix", null)
      tags                                   = lookup(lifecycle_rule.value, "tags", null)
      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)
      enabled                                = lifecycle_rule.value.enabled

      # Max 1 block - expiration
      dynamic "expiration" {
        for_each = length(keys(lookup(lifecycle_rule.value, "expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "expiration", {})]

        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      # Several blocks - transition
      dynamic "transition" {
        for_each = lookup(lifecycle_rule.value, "transition", [])

        content {
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }

      # Max 1 block - noncurrent_version_expiration
      dynamic "noncurrent_version_expiration" {
        for_each = length(keys(lookup(lifecycle_rule.value, "noncurrent_version_expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "noncurrent_version_expiration", {})]

        content {
          days = lookup(noncurrent_version_expiration.value, "days", null)
        }
      }

      # Several blocks - noncurrent_version_transition
      dynamic "noncurrent_version_transition" {
        for_each = lookup(lifecycle_rule.value, "noncurrent_version_transition", [])

        content {
          days          = lookup(noncurrent_version_transition.value, "days", null)
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  #checkov:skip=CKV2_AWS_6:Ensure that S3 bucket has a Public Access block
  #checkov:skip=CKV_AWS_55:Ensure S3 bucket has ignore public ACLs enabled
  #checkov:skip=CKV_AWS_54:Ensure S3 bucket has block public policy enabled
  #checkov:skip=CKV_AWS_56:Ensure S3 bucket has 'restrict_public_bucket' enabled
  #checkov:skip=CKV_AWS_53:Ensure S3 bucket has block public ACLS enabled
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  count = var.bucket_policy == "" ? 0 : 1

  bucket     = aws_s3_bucket.s3_bucket.id
  policy     = var.bucket_policy
  depends_on = [aws_s3_bucket_public_access_block.s3_bucket_public_access_block]
}
