locals {
  droplet_common_tags = merge(local.digitalocean_thrifty_common_tags, {
    service = "DigitalOcean/Droplet"
  })
}

benchmark "droplet" {
  title         = "Droplet Checks"
  description   = "Thrifty developers ensure that they delete unused droplet resources."
  documentation = file("./controls/docs/droplet.md")
  children = [
    control.droplet_long_running,
    control.droplet_snapshot_age_90
  ]

  tags = merge(local.droplet_common_tags, {
    type = "Benchmark"
  })
}

control "droplet_long_running" {
  title       = "Droplets created over 90 days ago should be reviewed"
  description = "Droplets created over 90 days ago should be reviewed and deleted if not required."
  severity    = "low"

  sql = <<-EOT
    select
      urn as resource,
      case
        when date_part('day', now() - created_at) > 90 and status = 'off' then 'alarm'
        when date_part('day', now() - created_at) > 90 then 'info'
        else 'ok'
      end as status,
      case
        when date_part('day', now() - created_at) > 90 and status = 'off'
        then title || ' instance status is ' || status || ', has been launced for ' || date_part('day', now() - created_at) || ' day(s).'
        else title || ' has been launced for ' || date_part('day', now() - created_at) || ' day(s).'
      end as reason,
      region ->> 'name' as region
    from
      digitalocean_droplet
  EOT

  tags = merge(local.droplet_common_tags, {
    class = "unused"
  })
}

control "droplet_snapshot_age_90" {
  title       = "Droplet snapshots created over 90 days ago should be deleted if not required"
  description = "Old droplet snapshots are likely unneeded and costly to maintain."
  severity    = "low"

  sql = <<-EOT
    select
      a.id as resource,
      case
        when a.created_at > current_timestamp - interval '90 days' then 'ok'
        else 'alarm'
      end as status,
      a.title || ' has been created for ' || date_part('day', now() - created_at) || ' day(s).' as reason,
      r.name
    from
      digitalocean_snapshot a,
      jsonb_array_elements_text(regions) as region,
      digitalocean_region r
    where region = r.slug and a.resource_type = 'droplet'
  EOT

  tags = merge(local.droplet_common_tags, {
    class = "unused"
  })
}
