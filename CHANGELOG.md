## v0.7 [2024-03-06]

_Powerpipe_

[Powerpipe](https://powerpipe.io) is now the preferred way to run this mod!  [Migrating from Steampipe →](https://powerpipe.io/blog/migrating-from-steampipe)

All v0.x versions of this mod will work in both Steampipe and Powerpipe, but v1.0.0 onwards will be in Powerpipe format only.

_Enhancements_

- Focus documentation on Powerpipe commands.
- Show how to combine Powerpipe mods with Steampipe plugins.

## v0.6 [2024-01-16]

_What's new?_

- Added the input variables to the following services to allow different thresholds to be passed in:
  - `Droplet`
  - `Database`
  - `Block Storage`
  - `Kubernetes`

To get started, please see [Digitalocean Thrifty Configuration] (https://hub.steampipe.io/mods/turbot/digitalocean_thrifty#configuration). For a list of variables and their default values, please see [steampipe.spvars](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/blob/main/steampipe.spvars). ([#36](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/pull/36))

## v0.5 [2023-06-08]

_What's new?_

- Added `connection_name` and `region` in the common dimensions to group and filter findings. (see [var.common_dimensions](https://hub.steampipe.io/mods/turbot/digitalocean_thrifty/variables)) ([#29](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/pull/29))
- Added `tags` as dimensions to group and filter findings. (see [var.tag_dimensions](https://hub.steampipe.io/mods/turbot/digitalocean_thrifty/variables)) ([#29](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/pull/29))

_Bug fixes_

- Fixed dashboard localhost URLs in README and index doc. ([#31](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/pull/31))

## v0.4 [2022-05-09]

_Enhancements_

- Updated docs/index.md and README with new dashboard screenshots and latest format. ([#22](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/pull/22))

## v0.3 [2022-05-02]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks and controls. ([#17](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/pull/17))

## v0.2 [2021-10-06]

_Enhancements_

- Updated: GitHub repository cloning instructions in docs/index.md now use HTTPS instead of SSH url

## v0.1 [2021-08-12]

_What's new?_

- Added initial Block Storage, Database, Droplet, Kubernetes and Network benchmarks
