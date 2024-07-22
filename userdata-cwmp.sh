#!/bin/bash

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
yum install python3 python3-pip -y
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable --now amazon-ssm-agent
yum install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install -i /usr/local/aws-cli -b /usr/bin
aws s3 cp s3://${bucket_name}/ . --recursive

python3 -m pip install ansible
chmod +x /usr/local/bin/ansible
PATH=/usr/local/bin:$PATH
sleep 5

#IP1=`aws ec2 describe-instances --filters "Name=tag:Name,Values=cwmp_name" --query 'Reservations[*].Instances[*].[PrivateIpAddress]' --output text`
#IP2=`aws ec2 describe-instances --filters "Name=tag:Name,Values=cwmp_name6" --query 'Reservations[*].Instances[*].[PrivateIpAddress]' --output text`

ansible-playbook playbook.yaml --extra-vars "version_dx=${version_dx} rabbit_instance=${rabbit_instance} cwmp=${cwmp} region_id_cwmp=${region_id_cwmp} MESSAGE_BROKER_PASSWORD=${MESSAGE_BROKER_PASSWORD} MESSAGE_BROKER_USERNAME=${MESSAGE_BROKER_USERNAME} MESSAGE_BROKER_ADDRESS=${MESSAGE_BROKER_ADDRESS}"