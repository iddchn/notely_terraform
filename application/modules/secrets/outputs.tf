output "mongodb_secret_arn" {
  value = aws_secretsmanager_secret.idan_notely_secrets.arn
}