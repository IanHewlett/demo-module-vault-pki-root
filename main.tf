resource "vault_mount" "pki" {
  path = "pki-${var.role}"
  type = "pki"

  default_lease_ttl_seconds = 86400
  max_lease_ttl_seconds     = 315360000
}

resource "vault_pki_secret_backend_root_cert" "root_cert" {
  backend     = vault_mount.pki.path
  type        = "internal"
  common_name = "istio-ca-vault"
  ttl         = 315360000
}

resource "vault_pki_secret_backend_config_urls" "config_urls" {
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["${var.vault_addr}/v1/pki/ca"]
  crl_distribution_points = ["${var.vault_addr}/v1/pki/crl"]
}
