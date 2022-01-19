# Terraform Graylog deploying script

## Description

This is a terraform script which deploying Ubuntu based OS into Digital Ocean Droplet and setting up Graylog server (Elasticsearch, logstash, Graylog, Filebeat, Mongodb, NGINX as revers proxy, AWS Route 52 as DNS provider)


## Requrements
- Digital Ocean account
- AWS account and DNS zone
- Terraform (>=0.14)
- Ansible >=2.10

## Main steps

# Terrafrom
1. Create Droplet
2. Create DNS name (AWS Route 52)
3. Import SSH key
4. Create inventory file for Ansible
5. Start Ansible-playbook [disabled by default]

# Ansible
1. Intarctive user input [graylog pass, smtp settings, nginx htpasswd(disabled), etc.]
2. Update system
3. Install requerements
4. Install NGINX
5. Install Elasticsearch
6. Install Logstash (GELF output)
  6.1 NGINX access log
  6.2 NGINX error log
  6.3 Syslog
7. Install Filebeat
8. Install Mongodb
9. Install Graylog 

## Usage

# Terraform

1. Clone this repo
2. Initialize plugins
```
terraform init
```
3. Edit varriables.tf according to your values

4. Edit terraform.tfvars according to your credentials

5. Check all config
```
terraform plan
```
If all is ok
6. Deploy VM
```
terraform apply
```

# Ansible
Check playbook
```
 ansible-playbook -i inventory.ini graylog.yml   --ssh-common-args='-o StrictHostKeyChecking=no' --private-key /path_for_your_key/key_name  --check
```
In check mode you will get errors

Run playbook
```
 ansible-playbook -i inventory.ini graylog.yml   --ssh-common-args='-o StrictHostKeyChecking=no' --private-key /path_for_your_key/key_name 
```


Ports:

Graylog port:8080
Elasticsearch port: 82 (ATTENTION!!! it's open)



## License

GNU GPL v3