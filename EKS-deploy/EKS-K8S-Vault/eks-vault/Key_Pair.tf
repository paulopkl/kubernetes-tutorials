resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "my_cert" {
  private_key_pem = tls_private_key.pv_key.private_key_pem

  subject {
    common_name = var.key_pair_name
  }

  allowed_uses          = ["key_encipherment", "digital_signature", "server_auth"]
  validity_period_hours = 8760 # 1 year
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.pv_key.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = pathexpand("~/.aws/${aws_key_pair.my_key_pair.key_name}.pem")
  content         = tls_private_key.pv_key.private_key_pem
  file_permission = "0400"
}
