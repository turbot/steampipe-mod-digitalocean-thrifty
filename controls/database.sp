variable "database_age_max_days" {
  type        = number
  description = "The maximum number of days databases are allowed to run."
  default     = 90
}

locals {
  database_common_tags = merge(local.digitalocean_thrifty_common_tags, {
    service = "DigitalOcean/Database"
  })
}

benchmark "database" {
  title         = "Database Checks"
  description   = "Thrifty developers ensure that they delete unused database resources."
  documentation = file("./controls/docs/database.md")
  children = [
    control.database_long_running
  ]

  tags = merge(local.database_common_tags, {
    type = "Benchmark"
  })
}

control "database_long_running" {
  title       = "Database clusters created over 90 days ago should be reviewed"
  description = "Database clusters created over 90 days ago should be reviewed and deleted if not required."
  severity    = "low"

  param "database_age_max_days" {
    description = "The maximum number of days databases are allowed to run."
    default     = var.database_age_max_days
  }

  sql = <<-EOQ
    select
      d.urn as resource,
      case
        when date_part('day', now() - d.created_at) > $1 then 'alarm'
        else 'ok'
      end as status,
      d.title || ' of ' || d.engine || ' type in use for ' || date_part('day', now() - d.created_at) || ' day(s).' as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "d.")}
    from
      digitalocean_database as d
      left join digitalocean_region as r on r.slug = d.region_slug;
  EOQ

  tags = merge(local.database_common_tags, {
    class = "unused"
  })
}
