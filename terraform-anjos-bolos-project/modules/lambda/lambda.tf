data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

resource "aws_lambda_function" "example" {
  filename      = "lambda_function.zip"
  function_name = "example_lambda"
  role          = data.aws_iam_role.lab_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"
  timeout       = 30

  source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_lambda_layer_version" "example_layer" {
  filename   = "layer.zip"
  layer_name = "example_layer"

  compatible_runtimes = ["python3.9"]

  source_code_hash = filebase64sha256("layer.zip")
}
