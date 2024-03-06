mod "digitalocean_thrifty" {
  # hub metadata
  title         = "DigitalOcean Thrifty"
  description   = "Are you a Thrifty DigitalOcean developer? This Powerpipe mod checks your DigitalOcean account(s) to check for unused and under utilized resources."
  color         = "#008bcf"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/digitalocean-thrifty.svg"
  categories    = ["digitalocean", "cost", "thrifty", "public cloud"]

  opengraph {
    title       = "Powerpipe Mod for DigitalOcean Thrifty"
    description = "Are you a Thrifty DigitalOcean dev? This Powerpipe mod checks your DigitalOcean account(s) for unused and under-utilized resources."
    image       = "/images/mods/turbot/digitalocean-thrifty-social-graphic.png"
  }
}
