// Benchmarks and controls for specific services should override the "service" tag
locals {
  digitalocean_thrifty_common_tags = {
    category = "Cost"
    plugin   = "digitalocean"
    service  = "DigitalOcean"
  }
}

variable "common_dimensions" {
  type        = list(string)
  description = "A list of common dimensions to add to each control."
  # Define which common dimensions should be added to each control.
  # - connection_name (_ctx ->> 'connection_name')
  # - region
  default = ["region"]
}

variable "tag_dimensions" {
  type        = list(string)
  description = "A list of tags to add as dimensions to each control."
  default     = []
}

locals {
  # Local internal variable to build the SQL select clause for common
  # dimensions using a table name qualifier if required. Do not edit directly.
  common_dimensions_qualifier_sql = <<-EOQ
  %{~if contains(var.common_dimensions, "connection_name")}, __QUALIFIER___ctx ->> 'connection_name' as connection_name%{endif~}
  %{~if contains(var.common_dimensions, "region")}, __QUALIFIER__name as region%{endif~}
  EOQ

  # Local internal variable to build the SQL select clause for tag
  # dimensions. Do not edit directly.
  tag_dimensions_qualifier_sql = <<-EOQ
  %{~for dim in var.tag_dimensions},  __QUALIFIER__tags ->> '${dim}' as "${replace(dim, "\"", "\"\"")}"%{endfor~} 
  EOQ
}

locals {
  # Local internal variable with the full SQL select clause for common
  # dimensions. Do not edit directly.
  common_dimensions_sql = replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "")
  tag_dimensions_sql    = replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "")
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