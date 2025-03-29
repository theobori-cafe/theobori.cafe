---
title: Teeworlds Terraform chaos engineering
date: "2024-06-05"
---

After doing some [chaos engineering for Terraform with the DOOM game](/posts/terraform_chaos_doom/), I wanted to make a version for Teeworlds, specifically for its version 0.7 (its latest version).

The difference with the DOOM version is that in this project, a player must capture the flag for a Terraform resource to be randomly destroyed.


## How does it work?

When configuring a Teeworlds server, the values below can be entered.

```bash
# Econ configuration
ec_port 7000
ec_password "hello_world"
ec_output_level 2
```


These are prefixed with `ec_` because they are associated with the `econ` server. This configuration binds a TCP port which will expose the Telnet protocol-based econ server.

Through the latter, we'll be able to retrieve events from the Teeworlds server, such as a message sent, a player killed or a flag captured !



<p align="center">
  <img src="/terraform_teeworlds_graph.png" class="img-center">
</p>



## Demonstration

This demonstration has been realized with the example Terraform project, every steps to reproduce it are detailed in the README file on the repository.

<p align="center" width="100%">
    <video controls width="80%">
        <source src="/teeworlds_terraform_demo.mp4" type="video/mp4">
        <a href="/teeworlds_terraform_demo.mp4">MP4</a>
    </video>
</p>



## Links

[https://github.com/theobori/terraform-teeworlds](https://github.com/theobori/terraform-teeworlds)
[https://github.com/theobori/teeworlds-econ](https://github.com/theobori/teeworlds-econ)

