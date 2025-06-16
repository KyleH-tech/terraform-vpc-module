# terraform-vpc-module

## 🧱 Architecture
This project deploys a secure AWS infrastructure using Terraform
- A custom VPC with public and private subnets
- A Bastion host in the public subnet for secure SSH access
- One or more private EC2 instances in private subnets
- NAT Gateways for outbound internet access from private instances
- Proper security group isolation

  
## 🌍 Resources Created

- VPC with CIDR block
- Public and private subnets across multiple AZs
- Internet Gateway and NAT Gateways
- Route tables for public and private traffic
- EC2 Bastion host with public IP
- EC2 Private instances (no public IP)
- Key Pair for SSH access
- Security Groups allowing:
  - SSH from your IP to Bastion
  - SSH from Bastion to Private instances
 
 
## ✅ Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.3
- AWS CLI configured with access keys
-  Set the two required agruments in your module resource block: "ami", "aws_region"


## 📦 Usage

module "vpc" {
  source     = "git::https://github.com/KyleH-tech/terraform-vpc-module.git?ref=v1.0.0"
  aws_region = "us-east-1"
  ami        = "ami-0c02fb55956c7d316"

}

```bash
# 1. Clone this repo
git clone https://github.com/KyleH-tech/terraform-bastion-ec2.git
cd terraform-bastion-ec2

# 2. Initialize Terraform
terraform init

# 3. Preview the execution plan
terraform plan

# 4. Apply the configuration
terraform apply


# Testing bastion host ssh access from local

1- Getting private key.pem after terraform apply, while on local machine.
terraform output -raw private_key_pem > ~\.ssh\terraform_generated_key.pem

2- setting the correct file permissions.
chmod 600 ~/.ssh/terraform_generated_key.pem

 3- Use the key to SSH into your bastion.
ssh -i ~/.ssh/terraform_generated_key.pem ec2-user@<bastion_public_ip>

4- Cat the private key_rsa and copy it
cat ~/.ssh/terraform_generated_key.pem

5- Inside the bastion, use this heredoc method to create the private key file if not present already:
echo "-----BEGIN RSA PRIVATE KEY-----
this will be the space for your rsa_bits
" > ~/.ssh/private_key.pem

6-Set proper file permissions again but this time within the bastion instance.
chmod 600 ~/.ssh/private_key.pem
 
7-SSH into your private instance (from within bastion):
ssh -i ~/.ssh/private_key.pem ec2-user@<PRIVATE_INSTANCE_PRIVATE_IP>



Inputs
"aws_region"	AWS region to deploy into	
"ami"	AMI ID for EC2 instances	

Outputs
"bastion_public_ip"	Public IP of the bastion instance
"private_key_pem" RSA private key

📌 Notes
Ensure your security group for the Bastion only allows your IP (x.x.x.x/32)
AWS charges apply for running EC2 instances and NAT Gateways
