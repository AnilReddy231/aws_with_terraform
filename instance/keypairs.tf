resource "aws_key_pair" "generated_key" {
  key_name   = "${var.env_name}_key"
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

