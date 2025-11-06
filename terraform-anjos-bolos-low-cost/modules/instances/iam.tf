# Usando LabRole existente - mesma abordagem das Lambdas
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}