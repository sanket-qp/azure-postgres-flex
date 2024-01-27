resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "foo" {
  content  = tls_private_key.this.private_key_pem
  filename = "/Users/sanket/keys/${local.prefix}-vm-private.pem"
  file_permission = "0400"
}
