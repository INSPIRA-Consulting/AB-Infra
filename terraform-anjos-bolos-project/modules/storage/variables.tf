variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "private_route_table_ids" {
  description = "IDs das route tables privadas"
  type        = list(string)
}
