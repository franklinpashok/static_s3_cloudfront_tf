output "bucket_name" {
  description = "The name of the created bucket"
  value       = aws_s3_bucket.s3_bucket.bucket
}

output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.s3_bucket.id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.s3_bucket.arn
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = aws_s3_bucket.s3_bucket.bucket_domain_name
}

output "s3_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}
