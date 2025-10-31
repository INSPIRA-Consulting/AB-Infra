variable "public_ip_host" {
    type = string
    description = "Valor do IP da instância pública"
    default = "0.0.0.0/0"
}

variable "private_ip_host" {
    type = string
    description = "Valor do IP da instância privada"
    default = "0.0.0.0/0"
}

variable "access_key" {
    type = string
    description = "Chave de acesso da AWS"
    default = "Sem chave"
}
