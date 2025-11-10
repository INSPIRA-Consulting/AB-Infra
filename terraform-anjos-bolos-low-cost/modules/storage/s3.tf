# Bucket principal para dados (usado pela Lambda)
resource "aws_s3_bucket" "bucket_raw" {
  bucket        = "bucket-raw-anjos-bolos"
  force_destroy = true 
}

# Bucket para backups do banco de dados
resource "aws_s3_bucket" "bucket_backup" {
  bucket        = "anjos-bolos-backup"
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

# Upload do arquivo de dados
resource "aws_s3_object" "vendas_confeitaria_csv" {
  bucket = aws_s3_bucket.bucket_raw.id
  key    = "data/vendas_confeitaria.csv"
  source = "${path.module}/data/vendas_confeitaria.csv"
  
  content_type = "text/csv"
  etag         = filemd5("${path.module}/data/vendas_confeitaria.csv")
}

# Upload das imagens de bolos
resource "aws_s3_object" "bolo_de_cenoura" {
  bucket = aws_s3_bucket.bucket_raw.id
  key    = "images/bolo_de_cenoura.png"
  source = "${path.module}/images/bolo_de_cenoura.png"
  
  content_type = "image/png"
  etag         = filemd5("${path.module}/images/bolo_de_cenoura.png")
}

resource "aws_s3_object" "bolo_de_chocolate" {
  bucket = aws_s3_bucket.bucket_raw.id
  key    = "images/bolo_de_chocolate.png"
  source = "${path.module}/images/bolo_de_chocolate.png"
  
  content_type = "image/png"
  etag         = filemd5("${path.module}/images/bolo_de_chocolate.png")
}

resource "aws_s3_object" "bolo_de_coco" {
  bucket = aws_s3_bucket.bucket_raw.id
  key    = "images/bolo_de_coco.png"
  source = "${path.module}/images/bolo_de_coco.png"
  
  content_type = "image/png"
  etag         = filemd5("${path.module}/images/bolo_de_coco.png")
}

resource "aws_s3_object" "bolo_de_fuba" {
  bucket = aws_s3_bucket.bucket_raw.id
  key    = "images/bolo-de-fuba.png"
  source = "${path.module}/images/bolo-de-fuba.png"
  
  content_type = "image/png"
  etag         = filemd5("${path.module}/images/bolo-de-fuba.png")
}

resource "aws_s3_object" "bolo_de_laranja" {
  bucket = aws_s3_bucket.bucket_raw.id
  key    = "images/bolo_de_laranja.png"
  source = "${path.module}/images/bolo_de_laranja.png"
  
  content_type = "image/png"
  etag         = filemd5("${path.module}/images/bolo_de_laranja.png")
}

resource "aws_s3_object" "bolo_de_limao" {
  bucket = aws_s3_bucket.bucket_raw.id
  key    = "images/bolo_de_limao.png"
  source = "${path.module}/images/bolo_de_limao.png"
  
  content_type = "image/png"
  etag         = filemd5("${path.module}/images/bolo_de_limao.png")
}

resource "aws_s3_object" "bolo_ninho_com_morango" {
  bucket = aws_s3_bucket.bucket_raw.id
  key    = "images/bolo_ninho_com_morango.png"
  source = "${path.module}/images/bolo_ninho_com_morango.png"
  
  content_type = "image/png"
  etag         = filemd5("${path.module}/images/bolo_ninho_com_morango.png")
}

resource "aws_s3_object" "bolo_prestigio" {
  bucket = aws_s3_bucket.bucket_raw.id
  key    = "images/bolo_prestigio.png"
  source = "${path.module}/images/bolo_prestigio.png"
  
  content_type = "image/png"
  etag         = filemd5("${path.module}/images/bolo_prestigio.png")
}

resource "aws_s3_object" "bolo_red_velvet" {
  bucket = aws_s3_bucket.bucket_raw.id
  key    = "images/bolo_red_velvet.png"
  source = "${path.module}/images/bolo_red_velvet.png"
  
  content_type = "image/png"
  etag         = filemd5("${path.module}/images/bolo_red_velvet.png")
}
