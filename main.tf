#### Describe providers
provider "digitalocean" {
  token = var.do_token
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.accesskey
  secret_key = var.secretkey
}

#### Import SSH key
resource "digitalocean_ssh_key" "default" {
  name       = "my_key_ssh"
  public_key = file("${path.module}/id_rsa.pub")
}

##### Looking for existing ssh
#data "digitalocean_ssh_key" "existingkey" {
#  name = "name_of_existinig_key"
#}

### Create new VM for graylog
resource "digitalocean_droplet" "graylog" {
  image  = "ubuntu-21-04-x64"
  name   = "graylog"
  region = "fra1"
  size   = "s-2vcpu-4gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint] #,data.digitalocean_ssh_key.existingkey.id
  tags = ["graylog","your_tags"]
}


### Using AWS DNS ZONE
data "aws_route53_zone" "zone1" {
  name         = "name_of_existinig_dns_zone."
}

resource "aws_route53_record" "graylog" {
  zone_id = data.aws_route53_zone.zone1.zone_id
  name    = "name.name1.${data.aws_route53_zone.zone1.name}"
  type    = "A"
  ttl     = "300"
  records = [digitalocean_droplet.graylog.ipv4_address]
}


### Rendering inventory file
resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tmpl",
    {
      ip1 = aws_route53_record.graylog.name
    }
  )
  filename = "${path.module}/inventory.ini"
}

### Starting ansible-playbook
#resource "null_resource" "play" {
#  provisioner "local-exec" {
#    command = "ansible-playbook  graylog.yml -i inventory.ini  --private-key /path_for_your_key/key_name --ssh-common-args='-o StrictHostKeyChecking=no' "
#  }
#  depends_on = [local_file.inventory]
#}

### Show me public ip
 output "public_ip_graylog" {
  value = digitalocean_droplet.graylog.ipv4_address
}

### Show me dns name
 output "dns_name_graylog" {
  value = aws_route53_record.graylog.name
}


