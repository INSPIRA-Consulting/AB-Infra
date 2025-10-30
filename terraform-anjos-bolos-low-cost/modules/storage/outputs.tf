output "bucket_raw_name" {
  description = "Nome do bucket S3 principal para dados"
  value       = aws_s3_bucket.bucket_raw.bucket
}

output "bucket_raw_arn" {
  description = "ARN do bucket S3 principal para dados"
  value       = aws_s3_bucket.bucket_raw.arn
}