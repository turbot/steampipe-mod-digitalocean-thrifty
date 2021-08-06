locals {
  database_common_tags = merge(local.thrifty_common_tags, {
    service = "database"
  })
}

benchmark "database" {
  title         = "Database Checks"
  description   = "Thrifty developers ensure delete unused database resources."
  documentation = file("./controls/docs/database.md")
  tags          = local.database_common_tags
  children = [
    control.database_long_running
  ]
}

control "database_long_running" {
  title       = "Database clusters created over 90 days ago should be reviewed"
  description = "Database clusters created over 90 days ago should be reviewed and deleted if not required."
  severity    = "low"

  sql = <<-EOT
    select
      -- Required Columns
      d.urn as resource,
      case
        when date_part('day', now() - d.created_at) > 90 then 'alarm'
        when date_part('day', now() - d.created_at) > 30 then 'info'
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

  tags = merge(local.database_common_tags, {
    class = "unused"
  })
}