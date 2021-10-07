variable "running_droplet_age_max_days" {
  type        = number
  description = "The maximum number of days droplets are allowed to run."
}

variable "droplet_snapshot_age_max_days" {
  type        = number
  description = "The maximum number of days snapshots can be retained."
}

locals {
  droplet_common_tags = merge(local.thrifty_common_tags, {
    service = "droplet"
  })
}

benchmark "droplet" {
  title         = "Droplet Checks"
  description   = "Thrifty developers ensure that they delete unused droplet resources."
  documentation = file("./controls/docs/droplet.md")
  tags          = local.droplet_common_tags
  children = [
    control.droplet_long_running,
    control.droplet_snapshot_age
  ]
}

control "droplet_long_running" {
  title       = "Long running droplets should be reviewed"
  description = "Long running droplets should be reviewed and deleted if not required."
  severity    = "low"

  sql = <<-EOT
    select
      urn as resource,
      case
        when date_part('day', now() - created_at) > $1 and status = 'off' then 'alarm'
        when date_part('day', now() - created_at) > $1 then 'info'
        else 'ok'
      end as status,
      case
        when date_part('day', now() - created_at) > $1 and status = 'off'
        then title || ' instance status is ' || status || ', has been launched for ' || date_part('day', now() - created_at) || ' day(s).'
        else title || ' has been launched for ' || date_part('day', now() - created_at) || ' day(s).'
      end as reason,
      region ->> 'name' as region
    from
      digitalocean_droplet;
  EOT

  param "running_droplet_age_max_days" {
    description = "The maximum number of days droplets are allowed to run."
    default     = var.running_droplet_age_max_days
  }

  tags = merge(local.droplet_common_tags, {
    class = "unused"
  })
}

control "droplet_snapshot_age" {
  title       = "Old droplet snapshots should be deleted if not required"
  description = "Old droplet snapshots are likely unneeded and costly to maintain."
  severity    = "low"

  sql = <<-EOT
    select
      a.id as resource,
      case
        when a.created_at > current_timestamp - interval '$1 days' then 'ok'
        else 'alarm'
      end as status,
      a.title || ' has been created for ' || date_part('day', now() - created_at) || ' day(s).' as reason,
      r.name as region
    from
      digitalocean_snapshot as a,
      jsonb_array_elements_text(regions) as region,
      digitalocean_region as r
    where
      region = r.slug
      and a.resource_type = 'droplet';
  EOT

  param "droplet_snapshot_age_max_days" {
    description = "The maximum number of days snapshots can be retained."
    default     = var.droplet_snapshot_age_max_days
  }

  tags = merge(local.droplet_common_tags, {
    class = "unused"
  })
}