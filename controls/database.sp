variable "database_running_cluster_age_max_days" {
  type        = number
  description = "The maximum number of days a database cluster is allowed to run."
}

variable "database_running_cluster_age_warning_days" {
  type        = number
  description = "The number of days after which a database cluster set a warning."
}

locals {
  database_common_tags = merge(local.thrifty_common_tags, {
    service = "database"
  })
}

benchmark "database" {
  title         = "Database Checks"
  description   = "Thrifty developers ensure that they delete unused database resources."
  documentation = file("./controls/docs/database.md")
  tags          = local.database_common_tags
  children = [
    control.database_long_running
  ]
}

control "database_long_running" {
  title       = "Long running database clusters should be reviewed"
  description = "Long running database clusters should be reviewed and deleted if not required."
  severity    = "low"

  sql = <<-EOT
    select
      -- Required Columns
      d.urn as resource,
      case
        when date_part('day', now() - d.created_at) > $1 then 'alarm'
        when date_part('day', now() - d.created_at) > $2 then 'info'
        else 'ok'
      end as status,
      d.title || ' of ' || d.engine || ' type in use for ' || date_part('day', now() - d.created_at) || ' day(s).' as reason,
      -- Additional Dimensions
      r.name as region
    from
      digitalocean_database as d,
      digitalocean_region as r
    where
      d.region_slug = r.slug;
  EOT

  param "database_running_cluster_age_max_days" {
    description = "The maximum number of days a database cluster is allowed to run."
    default     = var.database_running_cluster_age_max_days
  }

  param "database_running_cluster_age_warning_days" {
    description = "The number of days after which a database cluster set a warning."
    default     = var.database_running_cluster_age_warning_days
  }

  tags = merge(local.database_common_tags, {
    class = "unused"
  })
}