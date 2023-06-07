locals {
  block_storage_common_tags = merge(local.digitalocean_thrifty_common_tags, {
    service = "DigitalOcean/BlockStorage"
  })
}

benchmark "volume" {
  title         = "Block Storage Volume Checks"
  description   = "Thrifty developers ensure that they delete unused block storage volumes resources."
  documentation = file("./controls/docs/block_storage.md")
  children = [
    control.block_storage_volume_large,
    control.block_storage_volume_inactive_and_unused,
    control.block_storage_volume_snapshot_age_90
  ]

  tags = merge(local.block_storage_common_tags, {
    type = "Benchmark"
  })
}

control "block_storage_volume_large" {
  title       = "Large block storage volumes are unusual, expensive and should be reviewed."
  description = "Block storage volumes with over 100 GB should be resized if too large"
  severity    = "low"

  sql = <<-EOT
    select
      v.urn as resource,
      case
        when v.size_gigabytes <= 100 then 'ok'
        else 'alarm'
      end as status,
      v.id || ' is ' || v.size_gigabytes || 'GB.' as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "v.")}
    from
      digitalocean_volume as v,
      digitalocean_region r
    where
      v.region_slug = r.slug;
  EOT

  tags = merge(local.block_storage_common_tags, {
    class = "unused"
  })
}

control "block_storage_volume_inactive_and_unused" {
  title       = "Block storage volumes attached to stopped droplets should be reviewed"
  description = "Droplets that are stopped may no longer need any attached volumes."
  severity    = "low"

  sql = <<-EOT
    select
      v.urn as resource,
      case
        when d.id is null then 'alarm'
        when d.status <> 'active' then 'alarm'
        else 'ok'
      end as status,
      case
        when d.id is null then v.title || ' unattached.'
        when d.status = 'active' then  v.title || ' associated with droplet(s) ' || v.droplet_ids
        when d.status <> 'active' then v.title || ' associated with a stopped droplet.'
        else v.title || ' in use.'
      end as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "v.")}
    from
      digitalocean_region r,
      digitalocean_volume as v
      left join digitalocean_droplet as d on v.droplet_ids @> ('['||d.id||']'):: jsonb
    where
      v.region_slug = r.slug;
  EOT

  tags = merge(local.block_storage_common_tags, {
    class = "unused"
  })
}

control "block_storage_volume_snapshot_age_90" {
  title       = "Block storage volume snapshots created over 90 days ago should be deleted if not required"
  description = "Old snapshots are likely unneeded and costly to maintain."
  severity    = "low"

  sql = <<-EOT
    select
      a.id as resource,
      case
        when a.created_at > current_timestamp - interval '90 days' then 'ok'
        else 'alarm'
      end as status,
      a.title || ' has been created for ' || date_part('day', now() - a.created_at) || ' day(s).' as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      digitalocean_snapshot a,
      jsonb_array_elements_text(regions) as region,
      digitalocean_region r
    where region = r.slug and a.resource_type = 'volume';
  EOT

  tags = merge(local.block_storage_common_tags, {
    class = "unused"
  })
}
