output "images_bucket_name" {
  description = "Nome do bucket de imagens"
  value       = aws_s3_bucket.images.id
}

output "images_bucket_arn" {
  description = "ARN do bucket de imagens"
  value       = aws_s3_bucket.images.arn
}

output "backups_bucket_name" {
  description = "Nome do bucket de backups"
  value       = aws_s3_bucket.backups.id
}

output "backups_bucket_arn" {
  description = "ARN do bucket de backups"
  value       = aws_s3_bucket.backups.arn
}

output "s3_vpc_endpoint_id" {
  description = "ID do endpoint VPC do S3"
  value       = aws_vpc_endpoint.s3.id
}
