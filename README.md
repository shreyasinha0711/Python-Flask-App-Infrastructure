# Python-Flask-App-Infrastructure
Python-Flask-App-Infrastructure in Terraform

# deploy the services in AWS
Create your own key for ssh into EC2 instance using the below command
ssh-keygen -t rsa

chmod 400 <keyname>*

# deploy the terraform code to create resources in AWS
terraform init
terraform plan
terraform apply --auto-approve

# ssh into the EC2
copy jenkins_playbook.yaml file to path /home/ubuntu

# run ansible playbook
ansible-playbook jenkins_playbook.yaml

# run jenkins at public_ip of EC2 Instance at port 8080
EC2_public_ip:8080

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# configure a jenkins job and intergrate slack notification
git: https://github.com/shreyasinha0711/Python-Flask-Docker-App.git

# slack configuration
Team Subdomain: slackgitintegration
Workspace : slackgitintegration
password : secret text
Default channel / member id : jenkins-build

