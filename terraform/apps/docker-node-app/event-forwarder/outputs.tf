output "auth_token" {
  value = "${random_id.auth_token.hex}"
}
