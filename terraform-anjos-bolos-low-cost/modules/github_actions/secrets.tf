data "github_repository" "backend" {
  full_name = "INSPIRA-Consulting/AB-Back-end"
}

data "github_repository" "frontend" {
  full_name = "INSPIRA-Consulting/AB-Front-end"
}

resource "github_actions_organization_secret" "public_ip_host" {
  secret_name             = "REMOTE_HOST"
  visibility              = "selected"
  plaintext_value         = var.public_ip_host
  selected_repository_ids = [data.github_repository.backend.repo_id, data.github_repository.frontend.repo_id]
}

resource "github_actions_organization_secret" "private_ip_host" {
  secret_name             = "REMOTE_HOST_PRIVADO"
  visibility              = "selected"
  plaintext_value         = var.private_ip_host
  selected_repository_ids = [data.github_repository.backend.repo_id, data.github_repository.frontend.repo_id]
}

resource "github_actions_organization_secret" "ec2_ssh_key" {
  secret_name             = "EC2_SSH_KEY"
  visibility              = "selected"
  plaintext_value         = var.access_key
  selected_repository_ids = [data.github_repository.backend.repo_id, data.github_repository.frontend.repo_id]
}
