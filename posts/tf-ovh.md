---
title: Terraform OVH external DNS records
date: "2023-10-22"
---

Environment replication is always very useful, and I've always made sure that all my operations and work can be automated and replicated. For example, I've written Terraform configuration files for OVH DNS entries.

This turned out to be more useful than expected, given that I had to change server, I had to move everything and the automations saved me a lot of time, especially those linked to the machine's IP address.


## Requirements

The Terraform OVH provider requires certain environment variables:
- `OVH_ENDPOINT`
- `OVH_APPLICATION_KEY`
- `OVH_APPLICATION_SECRET`
- `OVH_CONSUMER_KEY`


To access them, simply go to [OVH's API token creation page](https://www.ovh.com/auth/api/createToken).

## Use cases

For [theobori.cafe](https://theobori.cafe), I used the following configurations.

**`providers.tf`**
```hcl
terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "0.34.0"
    }
  }
}

provider "ovh" {
  endpoint = "ovh-eu"
}
```



**`variables.tf`**
```hcl
variable "domain" {
  type        = string
  description = "The managed domain name"
}

variable "subdomains" {
  type        = set(string)
  description = "The subdomains directly link to `var.domain_name`"
  default = [
    "www",
    "status",
    "cringe",
    "etherpad",
    "search",
    "mail",
    "cloud"
  ]
}

variable "host" {
  type        = string
  description = "The target host IPv4 address"
  sensitive   = true
}

variable "host_ipv6" {
  type        = string
  description = "The target host IPv6 address"
  default     = null
  sensitive   = true
}

variable "dkim_key" {
  type        = string
  description = "The TXT DNS entry containing the DKIM key"
  default     = null
  sensitive   = true
}

variable "smtp_tlsa" {
  type        = string
  description = "The SMTP TLS fingerprint"
  default     = null
  sensitive   = true
}
```



**`main.tf`**
```hcl
resource "ovh_domain_zone_record" "domain" {
  zone      = var.domain
  fieldtype = "A"
  target    = var.host
}

resource "ovh_domain_zone_record" "www_domain" {
  zone      = var.domain
  subdomain = "www"
  fieldtype = "A"
  target    = var.host
}

resource "ovh_domain_zone_record" "mail" {
  zone      = var.domain
  fieldtype = "MX"
  ttl       = 300
  target    = "10 mail"
}

resource "ovh_domain_zone_record" "dmarc" {
  zone      = var.domain
  subdomain = "_dmarc"
  fieldtype = "TXT"
  target    = "v=DMARC1; p=none; rua=mailto:dmarc@${var.domain}"
}

resource "ovh_domain_zone_record" "spf" {
  for_each = toset(
    [
      "",
      "www"
    ]
  )

  zone      = var.domain
  subdomain = each.key
  fieldtype = "TXT"
  target    = "v=spf1 a mx -all"
}

resource "ovh_domain_zone_record" "www_txt" {
  zone      = var.domain
  fieldtype = "TXT"
  target    = "1|www.${var.domain}"
}

resource "ovh_domain_zone_record" "dkim_key" {
  count = var.dkim_key == null ? 0 : 1

  zone      = var.domain
  subdomain = "dkim._domainkey"
  fieldtype = "TXT"
  target    = var.dkim_key
}

resource "ovh_domain_zone_record" "subdomain_entries" {
  for_each = var.subdomains

  zone      = var.domain
  subdomain = each.key
  fieldtype = "A"
  target    = var.host
}

resource "ovh_domain_zone_record" "mail_ipv6" {
  count = var.host_ipv6 == null ? 0 : 1

  zone      = var.domain
  subdomain = "mail"
  fieldtype = "AAAA"
  target    = var.host_ipv6
}

resource "ovh_domain_zone_record" "smtp_fingerprint_tlsa" {
  count = var.smtp_tlsa == null ? 0 : 1

  zone      = var.domain
  subdomain = "_25._tcp.mail"
  fieldtype = "TLSA"
  target    = var.smtp_tlsa
}

resource "ovh_domain_zone_record" "autodiscover" {
  zone      = var.domain
  subdomain = "autodiscover"
  fieldtype = "CNAME"
  target    = "mail"
}

resource "ovh_domain_zone_record" "autoconfig" {
  zone      = var.domain
  subdomain = "autoconfig"
  fieldtype = "CNAME"
  target    = "mail"
}
```



## Links

[https://github.com/theobori-cafe/dns](https://github.com/theobori-cafe/dns)


