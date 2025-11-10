output "bucket_raw_name" {
  description = "Nome do bucket S3 principal para dados"
  value       = aws_s3_bucket.s3_raw_data.bucket
}

output "bucket_raw_arn" {
  description = "ARN do bucket S3 principal para dados"
  value       = aws_s3_bucket.s3_raw_data.arn
}

output "bucket_images_name" {
  description = "Nome do bucket S3 para imagens"
  value       = aws_s3_bucket.s3_raw_images.bucket
}

output "bucket_images_arn" {
  description = "ARN do bucket S3 para imagens"
  value       = aws_s3_bucket.s3_raw_images.arn
}

output "bucket_raw_url" {
  description = "URL base do bucket S3 de dados para acesso público"
  value       = "https://${aws_s3_bucket.s3_raw_data.bucket}.s3.amazonaws.com"
}

output "bucket_images_url" {
  description = "URL base do bucket S3 de imagens para acesso público"
  value       = "https://${aws_s3_bucket.s3_raw_images.bucket}.s3.amazonaws.com"
}

output "vendas_confeitaria_url" {
  description = "URL pública do arquivo CSV de vendas"
  value       = "https://${aws_s3_bucket.s3_raw_data.bucket}.s3.amazonaws.com/${aws_s3_object.vendas_confeitaria_csv.key}"
}

output "images_urls" {
  description = "URLs das imagens dos bolos"
  value = {
    bolo_de_cenoura         = "https://${aws_s3_bucket.s3_raw_images.bucket}.s3.amazonaws.com/${aws_s3_object.bolo_de_cenoura.key}"
    bolo_de_chocolate       = "https://${aws_s3_bucket.s3_raw_images.bucket}.s3.amazonaws.com/${aws_s3_object.bolo_de_chocolate.key}"
    bolo_de_coco           = "https://${aws_s3_bucket.s3_raw_images.bucket}.s3.amazonaws.com/${aws_s3_object.bolo_de_coco.key}"
    bolo_de_fuba           = "https://${aws_s3_bucket.s3_raw_images.bucket}.s3.amazonaws.com/${aws_s3_object.bolo_de_fuba.key}"
    bolo_de_laranja        = "https://${aws_s3_bucket.s3_raw_images.bucket}.s3.amazonaws.com/${aws_s3_object.bolo_de_laranja.key}"
    bolo_de_limao          = "https://${aws_s3_bucket.s3_raw_images.bucket}.s3.amazonaws.com/${aws_s3_object.bolo_de_limao.key}"
    bolo_ninho_com_morango = "https://${aws_s3_bucket.s3_raw_images.bucket}.s3.amazonaws.com/${aws_s3_object.bolo_ninho_com_morango.key}"
    bolo_prestigio         = "https://${aws_s3_bucket.s3_raw_images.bucket}.s3.amazonaws.com/${aws_s3_object.bolo_prestigio.key}"
    bolo_red_velvet        = "https://${aws_s3_bucket.s3_raw_images.bucket}.s3.amazonaws.com/${aws_s3_object.bolo_red_velvet.key}"
  }
}