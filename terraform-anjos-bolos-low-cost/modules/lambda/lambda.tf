data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# Criar um ZIP do código Python
data "archive_file" "lambda_zip_feriados" {
  type        = "zip"
  source_file = "${path.module}/../../scripts/lambdas_scripts/script1_download_to_s3.py"
  output_path = "${path.module}/lambda_function_feriados.zip"
}

# Criar um ZIP do código Python
data "archive_file" "lambda_zip_ipca" {
  type        = "zip"
  source_file = "${path.module}/../../scripts/lambdas_scripts/script1_crawler_ipca.py"
  output_path = "${path.module}/lambda_function_ipca.zip"
}


# Função Lambda
resource "aws_lambda_function" "crawler_feriados" {
  filename         = data.archive_file.lambda_zip_feriados.output_path
  function_name    = "Crawler-Feriados"
  role             = data.aws_iam_role.lab_role.arn
  handler          = "script1_download_to_s3.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip_feriados.output_base64sha256
  runtime          = "python3.11"
  timeout          = 600
  memory_size      = 128

  environment {
    variables = {
      S3_BUCKET_NAME = var.s3_bucket_name
    }
  }

  layers = ["arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python311:1"]

  tags = {
    Name        = "Crawler-Feriados"
    Environment = var.environment
    Project     = "anjos-bolos"
  }

  depends_on = [data.archive_file.lambda_zip_feriados]
}

# Layer xlrd
resource "aws_lambda_layer_version" "xlrd_layer" {
  filename            = "${path.module}/../../scripts/lambda_layer/xlrd-layer.zip"
  layer_name          = "xlrd-layer"
  compatible_runtimes = ["python3.11"]
  description         = "Layer com xlrd para leitura de arquivos Excel"
}

resource "aws_lambda_function" "crawler_ipca" {
  filename         = data.archive_file.lambda_zip_ipca.output_path
  function_name    = "Crawler-Ipca"
  role             = data.aws_iam_role.lab_role.arn
  handler          = "script1_crawler_ipca.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip_ipca.output_base64sha256
  runtime          = "python3.11"
  timeout          = 600
  memory_size      = 128

  environment {
    variables = {
      S3_BUCKET_NAME = var.s3_bucket_name
    }
  }

  layers = [
    "arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python311:1",
    aws_lambda_layer_version.xlrd_layer.arn
  ]

  tags = {
    Name        = "Crawler-Ipca"
    Environment = var.environment
    Project     = "anjos-bolos"
  }

  depends_on = [
    data.archive_file.lambda_zip_ipca,
    aws_lambda_layer_version.xlrd_layer
  ]
}