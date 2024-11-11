resource "tls_private_key" "ca_private_key" {
  algorithm  = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem = tls_private_key.ca_private_key.private_key_pem

  is_ca_certificate = true

  subject {
    country             = "US"
    province            = "State"
    locality            = "City"
    common_name         = "BytePen Studios CA"
    organization        = "BytePen Studios, LLC"
    organizational_unit = "BytePen Studios Root Certification Auhtority"
  }

  validity_period_hours = 43800 # 5 years

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}

resource "tls_private_key" "internal" {
  algorithm  = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_cert_request" "internal_csr" {
  private_key_pem = tls_private_key.internal.private_key_pem

  dns_names = ["dev.k3s.local"]

  subject {
    country             = "US"
    province            = "State"
    locality            = "City"
    common_name         = "BytePen Studios Development"
    organization        = "BytePen Studios, LLC"
    organizational_unit = "Development"
  }
}

resource "tls_locally_signed_cert" "internal" {
  cert_request_pem = tls_cert_request.internal_csr.cert_request_pem
  ca_private_key_pem = tls_private_key.ca_private_key.private_key_pem
  ca_cert_pem = tls_self_signed_cert.ca_cert.cert_pem

  validity_period_hours = 43800

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth",
  ]
}
