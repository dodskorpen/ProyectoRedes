# Droplets
resource "digitalocean_droplet" "themonitor" {
    image = "ubuntu-22-04-x64"
    name = "the-monitor"
    region = "nyc3"
    size = "s-1vcpu-1gb"
    monitoring = true
    resize_disk = false
    ssh_keys=[
        digitalocean_ssh_key.netkey.fingerprint,
    ]
    tags = [
        "networking",
        "monitor",
    ]
}


resource "digitalocean_droplet" "thevpn" {
    image = "ubuntu-22-04-x64"
    name = "the-vpn"
    region = "nyc3"
    size = "s-1vcpu-1gb"
    monitoring = true
    resize_disk = false
    ssh_keys=[
        digitalocean_ssh_key.netkey.fingerprint,
    ]
    tags = [
        "networking",
        "vpn",
    ]
}

# Static IP's for each droplet
resource "digitalocean_reserved_ip"  "themonitorip" {
    droplet_id = digitalocean_droplet.themonitor.id
    region = digitalocean_droplet.themonitor.region
}

resource "digitalocean_reserved_ip" "thevpnip" {
    droplet_id = digitalocean_droplet.thevpn.id
    region = digitalocean_droplet.thevpn.region
}
