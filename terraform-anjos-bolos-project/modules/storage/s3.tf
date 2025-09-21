resource "aws_s3_bucket" "bucket_imagens" {
  bucket = "s3-imagem-anjos-bolos"
}

resource "aws_s3_bucket_public_access_block" "bloco_acesso_publico_s3" {
  bucket = aws_s3_bucket.bucket_imagens.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "politica_acesso_publico_bucket" {
  bucket = aws_s3_bucket.bucket_imagens.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.bucket_imagens.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.bloco_acesso_publico_s3]
}