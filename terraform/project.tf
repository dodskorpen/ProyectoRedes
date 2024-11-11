resource "digitalocean_project" "networking" {
    name = "networking"
    description = "The final project for networking"
    purpose = "Web Application"
    environment = "Production"

    resources = [
        digitalocean_droplet.themonitor.urn,
        digitalocean_droplet.thevpn.urn,
        digitalocean_reserved_ip.themonitorip.urn,
        digitalocean_reserved_ip.thevpnip.urn,
    ]
}

