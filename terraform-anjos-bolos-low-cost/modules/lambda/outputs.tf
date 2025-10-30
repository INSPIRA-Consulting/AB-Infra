output "lambda_function_arn" {
  description = "ARN da função Lambda Crawler-Feriados"
  value       = aws_lambda_function.crawler_feriados.arn
}

output "lambda_function_name" {
  description = "Nome da função Lambda"
  value       = aws_lambda_function.crawler_feriados.function_name
}

output "lambda_invoke_arn" {
  description = "ARN de invocação da função Lambda"
  value       = aws_lambda_function.crawler_feriados.invoke_arn
}

output "lambda_qualified_arn" {
  description = "ARN qualificado da função Lambda"
  value       = aws_lambda_function.crawler_feriados.qualified_arn
}