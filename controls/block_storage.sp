variable "block_storage_volume_max_size_gb" {
  type        = number
  description = "The maximum size in GB allowed for volumes."
}

variable "block_storage_volume_snapshot_age_max_days" {
  type        = number
  description = "The maximum number of days a snapshot can be retained."
}

locals {
  block_storage_common_tags = merge(local.thrifty_common_tags, {
    service = "volume"
  })
}

benchmark "volume" {
  title         = "Block Storage Volume Checks"
  description   = "Thrifty developers ensure that they delete unused block storage volumes resources."
  documentation = file("./controls/docs/block_storage.md")
  tags          = local.block_storage_common_tags
  children = [
    control.block_storage_volume_large,
    control.block_storage_volume_inactive_and_unused,
    control.block_storage_volume_snapshot_age
  ]
}

control "block_storage_volume_large" {
  title       = "Large block storage volumes are unusual, expensive and should be reviewed."
  description = "Block storage volumes with over ${var.block_storage_volume_max_size_gb} GB should be resized if too large."
  severity    = "low"

  sql = <<-EOT
    select
      urn as resource,
      case
        when size_gigabytes <= $1 then 'ok'
        else 'alarm'
      end as status,
      id || ' is ' || size_gigabytes || ' GB.' as reason,
      region_name as region
    from
      digitalocean_volume;
  EOT

  param "block_storage_volume_max_size_gb" {
    default = var.block_storage_volume_max_size_gb
  }

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
      end as reason,
      v.region_name
    from
      digitalocean_volume as v
      left join digitalocean_droplet as d on v.droplet_ids @> ('['||d.id||']'):: jsonb;
  EOT

  tags = merge(local.block_storage_common_tags, {
    class = "unused"
  })
}

control "block_storage_volume_snapshot_age" {
  title       = "Block storage volume snapshots created over ${var.block_storage_volume_snapshot_age_max_days} days ago should be deleted if not required."
  description = "Old snapshots are likely unneeded and costly to maintain."
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
      and a.resource_type = 'volume';
  EOT

  param "block_storage_volume_snapshot_age_max_days" {
    default = var.block_storage_volume_snapshot_age_max_days
  }

  tags = merge(local.block_storage_common_tags, {
    class = "unused"
  })
}
