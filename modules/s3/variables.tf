variable "bucket_name" {
  description = "Name of S3 bucket"
  type        = string
}

variable "target_bucket" {
  description = "Name of S3 target bucket"
  type        = string
  default     = ""
}

variable "versioning_enabled" {
  description = "If true, enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "acl" {
  description = "Private or Public ACL"
  type        = string
  default     = "private"
}

variable "block_public_acls" {
  description = "Whether or not to block public acls"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether or not to block public policy"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether or not to ignore public acls"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether or not to restrict public buckets"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to be appended to ECR Repo"
  type        = map(string)
  default     = {}
}

variable "bucket_policy" {
  description = "Bucket policy to be added to bucket"
  type        = string
  default     = ""
}

variable "lifecycle_transition_rule_enabled" {
  description = "Whether or not to enable the transition lifecycle rule"
  type        = bool
  default     = false
}

variable "current_version_transition_days" {
  description = "No of days after transition of objects happens"
  type        = number
  default     = 30
}

variable "current_version_transition_class" {
  description = "Which class to transition to"
  type        = string
  default     = "GLACIER"
}

variable "expired_object_delete_marker" {
  description = "Whether or not to check the expired object delete marker"
  type        = bool
  default     = true
}

variable "expired_object_permanent_deletion_days" {
  description = "No of days after delete objects from glacier and S3"
  type        = number
  default     = 90
}

variable "lifecycle_rule_enabled" {
  description = "Whether or not to enable the lifecycle rule"
  type        = bool
  default     = false
}

variable "noncurrent_version_expiration_days" {
  description = "No of days after expiring previous versions of objects"
  type        = number
  default     = 90
}

variable "lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}

variable "cors_rule" {
  description = "Map containing a rule of Cross-Origin Resource Sharing."
  type        = any # should be `map`, but it produces an error "all map elements must have the same type"
  default     = {}
}

variable "server_side_encryption_configuration" {
  type        = map(any)
  description = "Server-side Encryption (SSE) Configuration of S3 Bucket"
  default     = {}
}
