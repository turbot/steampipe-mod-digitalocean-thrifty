# DigitalOcean Thrifty Mod for Powerpipe

> [!IMPORTANT]
> Steampipe mods are [migrating to Powerpipe format](https://powerpipe.io) to gain new features. This mod currently works with both Steampipe and Powerpipe, but will only support Powerpipe from v1.x onward.

Are you a Thrifty DigitalOcean dev? This Powerpipe mod checks your DigitalOcean account(s) for unused and under-utilized resources.

Run checks in a dashboard:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-digitalocean-thrifty/main/docs/digitalocean_thrifty_dashboard.png)

## Documentation

- **[Benchmarks and controls →](https://hub.powerpipe.iop/mods/turbot/digitalocean_thrifty/controls)**
- **[Named queries →](https://hub.powerpipe.iop/mods/turbot/digitalocean_thrifty/queries)**

## Getting Started

### Installation

Install Powerpipe (https://powerpipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/powerpipe
```

This mod also requires [Steampipe](https://steampipe.io) with the [DigitalOcean plugin](https://hub.steampipe.io/plugins/turbot/digitalocean) as the data source. Install Steampipe (https://steampipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/steampipe
steampipe plugin install digitalocean
```

Finally, install the mod:

```sh
mkdir dashboards
cd dashboards
powerpipe mod init
powerpipe mod install github.com/turbot/steampipe-mod-digitalocean-thrifty
```

### Browsing Dashboards

Start Steampipe as the data source:

```sh
steampipe service start
```

Start the dashboard server:

```sh
powerpipe server
```

Browse and view your dashboards at **http://localhost:9033**.

### Running Checks in Your Terminal

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `powerpipe benchmark` command:

List available benchmarks:

```sh
powerpipe benchmark list
```

Run a benchmark:

```sh
powerpipe benchmark run digitalocean_thrifty.benchmark.droplet
```

Different output formats are also available, for more information please see
[Output Formats](https://powerpipe.io/docs/reference/cli/benchmark#output-formats).

### Configure Variables

Several benchmarks have [input variables](https://powerpipe.io/docs/build/mod-variables#input-variables) that can be configured to better match your environment and requirements. Each variable has a default defined in its source file, e.g., `controls/droplet.sp`, but these can be overwritten in several ways:

It's easiest to setup your vars file, starting with the sample:

```sh
cp steampipe.spvars.example steampipe.spvars
vi steampipe.spvars
```

Alternatively you can pass variables on the command line:

```sh
powerpipe benchmark run droplet --var=droplet_snapshot_age_max_days=90
```

Or through environment variables:

```sh
export PP_VAR_droplet_snapshot_age_max_days=90 
powerpipe control run droplet_snapshot_age_90
```

These are only some of the ways you can set variables. For a full list, please see [Passing Input Variables](https://powerpipe.io/docs/build/mod-variables#passing-input-variables).

### Common and Tag Dimensions

The benchmark queries use common properties (like `connection_name` and `region`) and tags that are defined in the form of a default list of strings in the `mod.sp` file. These properties can be overwritten in several ways:

It's easiest to setup your vars file, starting with the sample:

```sh
cp steampipe.spvars.example steampipe.spvars
vi steampipe.spvars
```

Alternatively you can pass variables on the command line:

```sh
powerpipe benchmark run digitalocean_thrifty.benchmark.droplet --var 'common_dimensions=["connection_name", "region"]'
powerpipe benchmark run digitalocean_thrifty.benchmark.droplet --var 'tag_dimensions=["Environment", "Owner"]'
```

Or through environment variables:

```sh
export PP_VAR_common_dimensions='["connection_name", "region"]'
export PP_VAR_tag_dimensions='["Environment", "Owner"]'
powerpipe benchmark run digitalocean_thrifty.benchmark.droplet
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) and [Powerpipe](https://powerpipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [DigitalOcean Thrifty Mod](https://github.com/turbot/steampipe-mod-digitalocean-thrifty/labels/help%20wanted)
