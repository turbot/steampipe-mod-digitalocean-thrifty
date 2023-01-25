// Benchmarks and controls for specific services should override the "service" tag
locals {
  digitalocean_thrifty_common_tags = {
    category = "Cost"
    plugin   = "digitalocean"
    service  = "DigitalOcean"
  }
}

variable "tag_dimensions" {
  type        = list(string)
  description = "A list of tags to add as dimensions to each control."
  default     = [ "Owner" ]
}

locals {

  tag_dimensions_sql = <<-EOQ
  %{~ for dim in var.tag_dimensions }, tags ->> '${dim}' as "${replace(dim, "\"", "\"\"")}"%{ endfor ~}
  EOQ

}

mod "digitalocean_thrifty" {
  # hub metadata
  title         = "DigitalOcean Thrifty"
  description   = "Are you a Thrifty DigitalOcean developer? This Steampipe mod checks your DigitalOcean account(s) to check for unused and under utilized resources."
  color         = "#008bcf"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/digitalocean-thrifty.svg"
  categories    = ["digitalocean", "cost", "thrifty", "public cloud"]

  opengraph {
    title       = "Thrifty mod for DigitalOcean"
    description = "Are you a Thrifty DigitalOcean dev? This Steampipe mod checks your DigitalOcean account(s) for unused and under-utilized resources."
    image       = "/images/mods/turbot/digitalocean-thrifty-social-graphic.png"
  }
}