---
title: Terraform NeuVector provider
date: "2023-06-04"
---

This project is used to manage NeuVector's configuration and its most revelant resources. I was asked to automate the configuration of the solution in a fairly specific context. Initially, I had made a rather well-organized bash script that could apply these resources, but not destroy them.

I then asked around and very quickly found Terraform. So I learned how to use it and made a module that could manage any NeuVector resource, including creation and destruction only.

A huge problem was the token that NeuVector provides tends to timeout quite quickly (300 seconds by default).

So I decided to create a Terraform provider to handle all this cleanly. The language best suited for this is Go, so I learned it. Hashicorp explains that it's best to separate the client library from the provider.

<p align="center" width="100%">
    <img src="/terraform_provider.png" width="90%">
</p>

So I created a Go SDK for NeuVector before using it in the provider.


Now the provider is able to fully manage the implemented resources (create, delete, update and import).

## Use cases

The provider Terraform block looks like below.

```hcl
terraform {
  required_providers {
    neuvector = {
      source = "theobori/neuvector"
      version = "0.4.1"
    }
  }
}

provider "neuvector" {
  base_url = "https://127.0.0.1:10443/v1/"
  username = "admin"
  password = "admin"
}
```



Once it is declared in the configuration, you can start using it as you want. Here's a Terraform example that could be applied after installing NeuVector.

```hcl
resource "neuvector_eula" "eula" {
    accepted = true
}

resource "neuvector_registry" "registry_test" {
  name                   = "docker.io"
  registry_type          = "Docker Registry"
  filters                = ["*"]
  registry               = "https://registry.hub.docker.com/"
  rescan_after_db_update = true
  auth_with_token        = false
  scan_layers            = true
}

resource "neuvector_group" "group_test" {
  name = "mytestgroup"

  criteria {
    key   = "pattern"
    value = "[a-z]"
    op    = "regex"
  }

  criteria {
    key   = "namespace"
    value = "example"
    op    = "="
  }
}

data "neuvector_group_metadata" "group_metadata" {
    name = neuvector_group.group_test.id
}

resource "neuvector_service_config" "service_config_test" {
  services = data.neuvector_group_services.group_metadata.services

  not_scored = true
}
```


## Links

[https://github.com/theobori/terraform-provider-neuvector](https://github.com/theobori/terraform-provider-neuvector)
[https://registry.terraform.io/providers/theobori/neuvector](https://registry.terraform.io/providers/theobori/neuvector/latest)


