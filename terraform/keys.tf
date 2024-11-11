resource "digitalocean_ssh_key" "netkey" {
    name       = "netkey"
    public_key = file("~/.ssh/id_ed25519.pub")
}