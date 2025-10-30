# Bucket principal para dados (usado pela Lambda)
resource "aws_s3_bucket" "bucket_raw" {
  bucket        = "bucket-raw-anjos-bolos-1"
  force_destroy = true 
}

# 12.1. Desativa o Block Public Access para permitir acesso público
resource "aws_s3_bucket_public_access_block" "bloco_acesso_publico_s3" {
  bucket = aws_s3_bucket.bucket_raw.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 12.2. Define a política do bucket para permitir acesso público a todos os objetos
resource "aws_s3_bucket_policy" "politica_acesso_publico_bucket" {
  bucket = aws_s3_bucket.bucket_raw.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.bucket_raw.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.bloco_acesso_publico_s3]
}