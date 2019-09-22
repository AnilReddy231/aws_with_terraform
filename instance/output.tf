output "rootUserPassword" {
  value = "${random_string.rootUserPassword.result}"
}

output "monitorUserPassword" {
    value = "${random_string.monitorUserPassword.result}"
}

output "generated_key" {
	value = "${tls_private_key.ssh.private_key_pem}"
}