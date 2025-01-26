resource "aws_secretsmanager_secret" "idan_notely_secrets" {
  name = "idan_notely_secrets"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "mongodb_uri" {
  secret_id = aws_secretsmanager_secret.idan_notely_secrets.id
  secret_string = jsonencode({
    mongodb_uri = base64encode("mongodb://${var.mongodb_user}:${var.mongodb_password}@${var.mongodb_host}")
  })
}