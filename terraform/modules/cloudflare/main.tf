terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  email = "you@example.com"
  api_token = "your-api-token"
}

variable "zone_id" {
  default = "e097e1136dc79bc1149e32a8a6bde5ef"
}

variable "domain" {
  default = "example.com"
}

resource "cloudflare_record" "www" {
  zone_id = var.zone_id
  name    = "www"
  value   = "203.0.113.10"
  type    = "A"
  proxied = true
}