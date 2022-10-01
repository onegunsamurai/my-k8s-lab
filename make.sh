#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Please provide github access token."
	exit
fi


GIT_TOKEN=$1

echo "Checking Requirements..."
# Check requirements are installed
if ! command -v aws &> /dev/null 
then 
    # (AWS)
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
fi

if ! command -v terraform &> /dev/null 
then 
    # (Terraform)
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt-get install terraform
fi 

if ! command -v terragrunt &> /dev/null 
then 
	# (Terragrunt)
	wget -q https://github.com/gruntwork-io/terragrunt/releases/download/v0.38.3/terragrunt_linux_amd64
	mv terragrunt_linux_amd64 terragrunt
	chmod u+x terragrunt
	sudo mv terragrunt /bin/
fi 
echo "Requirements installed"

# Put Neccessary Secrets to Parameter Store
aws ssm put-parameter --name access_key --value $(aws configure get aws_access_key_id) --type SecureString --overwrite
aws ssm put-parameter --name secret_key --value $(aws configure get aws_secret_access_key) --type SecureString --overwrite
aws ssm put-parameter --name /github/Token --value $GIT_TOKEN --type SecureString --overwrite

cd terraform/env/dev #Unhardcode later
terragrunt run-all init
terragrunt run-all apply --auto-approve