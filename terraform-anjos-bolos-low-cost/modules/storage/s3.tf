# Bucket principal para dados (usado pela Lambda)
resource "aws_s3_bucket" "s3_raw_data" {
  bucket        = "s3-raw-anjos-bolos-data"
  force_destroy = true 
}

# Bucket específico para imagens
resource "aws_s3_bucket" "s3_raw_images" {
  bucket        = "s3-anjos-bolos-images"
  force_destroy = true 
}

# Bucket para backups do banco de dados
resource "aws_s3_bucket" "bucket_backup" {
  bucket        = "s3-anjos-bolos-backup"
  force_destroy = true
}

# 12.1. Desativa o Block Public Access para bucket de dados
resource "aws_s3_bucket_public_access_block" "bloco_acesso_publico_data" {
  bucket = aws_s3_bucket.s3_raw_data.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 12.1b. Desativa o Block Public Access para bucket de imagens  
resource "aws_s3_bucket_public_access_block" "bloco_acesso_publico_images" {
  bucket = aws_s3_bucket.s3_raw_images.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 12.2. Define a política do bucket de dados para permitir acesso público
resource "aws_s3_bucket_policy" "politica_acesso_publico_data" {
  bucket = aws_s3_bucket.s3_raw_data.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.s3_raw_data.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.bloco_acesso_publico_data]
}

# 12.2b. Define a política do bucket de imagens para permitir acesso público
resource "aws_s3_bucket_policy" "politica_acesso_publico_images" {
  bucket = aws_s3_bucket.s3_raw_images.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.s3_raw_images.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.bloco_acesso_publico_images]
}

# Upload do arquivo de dados para o bucket de dados
resource "aws_s3_object" "vendas_confeitaria_csv" {
  bucket = aws_s3_bucket.s3_raw_data.id
  key    = "data/vendas_confeitaria.csv"
  source = "${path.module}/data/vendas_confeitaria.csv"
  
  content_type = "text/csv"
  etag         = filemd5("${path.module}/data/vendas_confeitaria.csv")
  
  tags = {
    Name        = "Dados de Vendas da Confeitaria"
    Environment = "low-cost"
    Type        = "data"
  }
}

# Upload das imagens de bolos para o bucket de imagens
resource "aws_s3_object" "bolo_de_cenoura" {
  bucket = aws_s3_bucket.s3_raw_images.id
  key    = "bolo_de_cenoura.jpg"
  source = "${path.module}/images/bolo_de_cenoura.jpg"
  
  content_type = "image/jpg"
  etag         = filemd5("${path.module}/images/bolo_de_cenoura.jpg")
  
  tags = {
    Name        = "Imagem Bolo de Cenoura"
    Environment = "low-cost"
    Type        = "image"
  }
}

resource "aws_s3_object" "bolo_de_chocolate" {
  bucket = aws_s3_bucket.s3_raw_images.id
  key    = "bolo_de_chocolate.jpg"
  source = "${path.module}/images/bolo_de_chocolate.jpg"
  
  content_type = "image/jpg"
  etag         = filemd5("${path.module}/images/bolo_de_chocolate.jpg")
  
  tags = {
    Name        = "Imagem Bolo de Chocolate"
    Environment = "low-cost"
    Type        = "image"
  }
}

resource "aws_s3_object" "bolo_de_coco" {
  bucket = aws_s3_bucket.s3_raw_images.id
  key    = "bolo_de_coco.jpg"
  source = "${path.module}/images/bolo_de_coco.jpg"
  
  content_type = "image/jpg"
  etag         = filemd5("${path.module}/images/bolo_de_coco.jpg")
  
  tags = {
    Name        = "Imagem Bolo de Coco"
    Environment = "low-cost"
    Type        = "image"
  }
}

resource "aws_s3_object" "bolo_de_fuba" {
  bucket = aws_s3_bucket.s3_raw_images.id
  key    = "bolo-de-fuba.jpg"
  source = "${path.module}/images/bolo-de-fuba.jpg"
  
  content_type = "image/jpg"
  etag         = filemd5("${path.module}/images/bolo-de-fuba.jpg")
  
  tags = {
    Name        = "Imagem Bolo de Fubá"
    Environment = "low-cost"
    Type        = "image"
  }
}

resource "aws_s3_object" "bolo_de_laranja" {
  bucket = aws_s3_bucket.s3_raw_images.id
  key    = "bolo_de_laranja.jpg"
  source = "${path.module}/images/bolo_de_laranja.jpg"
  
  content_type = "image/jpg"
  etag         = filemd5("${path.module}/images/bolo_de_laranja.jpg")
  
  tags = {
    Name        = "Imagem Bolo de Laranja"
    Environment = "low-cost"
    Type        = "image"
  }
}

resource "aws_s3_object" "bolo_de_limao" {
  bucket = aws_s3_bucket.s3_raw_images.id
  key    = "bolo_de_limao.jpg"
  source = "${path.module}/images/bolo_de_limao.jpg"
  
  content_type = "image/jpg"
  etag         = filemd5("${path.module}/images/bolo_de_limao.jpg")
  
  tags = {
    Name        = "Imagem Bolo de Limão"
    Environment = "low-cost"
    Type        = "image"
  }
}

resource "aws_s3_object" "bolo_ninho_com_morango" {
  bucket = aws_s3_bucket.s3_raw_images.id
  key    = "bolo_ninho_com_morango.jpg"
  source = "${path.module}/images/bolo_ninho_com_morango.jpg"
  
  content_type = "image/jpg"
  etag         = filemd5("${path.module}/images/bolo_ninho_com_morango.jpg")
  
  tags = {
    Name        = "Imagem Bolo Ninho com Morango"
    Environment = "low-cost"
    Type        = "image"
  }
}

resource "aws_s3_object" "bolo_prestigio" {
  bucket = aws_s3_bucket.s3_raw_images.id
  key    = "bolo_prestigio.jpg"
  source = "${path.module}/images/bolo_prestigio.jpg"
  
  content_type = "image/jpg"
  etag         = filemd5("${path.module}/images/bolo_prestigio.jpg")
  
  tags = {
    Name        = "Imagem Bolo Prestígio"
    Environment = "low-cost"
    Type        = "image"
  }
}

resource "aws_s3_object" "bolo_red_velvet" {
  bucket = aws_s3_bucket.s3_raw_images.id
  key    = "bolo_red_velvet.jpg"
  source = "${path.module}/images/bolo_red_velvet.jpg"
  
  content_type = "image/jpg"
  etag         = filemd5("${path.module}/images/bolo_red_velvet.jpg")
  
  tags = {
    Name        = "Imagem Bolo Red Velvet"
    Environment = "low-cost"
    Type        = "image"
  }
}