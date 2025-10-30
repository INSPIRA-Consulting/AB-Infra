variable "s3_bucket_name" {
  description = "Nome do bucket S3 para armazenar os dados dos feriados"
  type        = string
}

variable "lab_role_arn" {
  description = "ARN da LabRole para a função Lambda"
  type        = string
  default     = "arn:aws:iam::713867857874:role/LabRole"
}

variable "pandas_layer_arn" {
  description = "ARN da layer do Pandas para a função Lambda"
  type        = string
  default     = "arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python311:14"
}

variable "environment" {
  description = "Ambiente de implantação (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "scheduler_expression" {
  description = "Expressão de agendamento para execução da Lambda (formato CloudWatch Events)"
  type        = string
  default     = "rate(30 days)"
}