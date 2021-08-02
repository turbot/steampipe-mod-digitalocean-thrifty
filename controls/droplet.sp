locals {
  droplet_common_tags = merge(local.thrifty_common_tags, {
    service = "droplet"
  })
}

benchmark "droplet" {
  title         = "Droplet Checks"
  description   = "Thrifty developers ensure delete unused droplet resources."
  documentation = file("./controls/docs/database.md")
  tags          = local.database_common_tags
  children = [
    control.droplet_long_running
  ]
}

control "droplet_long_running" {
  title       = "Droplet created over 90 days ago should be reviewed"
  description = "Droplet created over 90 days ago should be reviewed and deleted if not required."
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
