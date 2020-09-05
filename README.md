# terraform-chef-immersion
Terraform module for creating Chef training environment

## Requirements
 - Terraform CLI version >= 0.13
 ```bash
 brew install hashicorp/tap/terraform
 ```
 Or check the installation [documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli)
 
 - AWS Account
 
## How to use
### Pre-configurations

1. Configure AWS account credentials to be used with this module. <br />

.aws/config
```
[profile hazel-lab]
region = us-east-1
output = table
```
.aws/credentials
```
[hazel-lab]
aws_access_key_id = ****
aws_secret_access_key = ****
```
2. Generate SSH keys within the `terraform-chef-immersion/ssh-keys/` directory
```bash
ssh-keygen -t rsa -f chef-immersion
chmod 400 ./chef-immersion
```
:information_source: &nbsp; If you call the SSH keys something other than `chef-immersion` you must change it in the terraform module as well.

### Variables
1. Copy `terraform.tfvars.example` to `terraform.tfvars`
```bash
cp terraform.tfvars.example terraform.tfvars
```
2. Modify the values for at least all the required variables and save

### Deploy
1. Initialize Terraform
```bash
terraform init
```
2. Validate Terraform configuration
```bash
terraform validate
```
3. Apply Terraform configuration
```bash
terraform apply
```
