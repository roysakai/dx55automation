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
IP1=`aws ec2 describe-instances --filters "Name=tag:Name,Values=${acs_name}" --query 'Reservations[*].Instances[*].[PrivateIpAddress]' --output text`
IP2=`aws ec2 describe-instances --filters "Name=tag:Name,Values=${acs_name6}" --query 'Reservations[*].Instances[*].[PrivateIpAddress]' --output text`

ansible-playbook playbook.yaml --extra-vars "rabbit_instance=${rabbit_instance_acs} acs=${acs} REDIS_CONS=${REDIS_CONS} REDIS_PASSWORD=${REDIS_PASSWORD} host_db=${host_db} port_db=${port_db} username=${username} password=${password} MESSAGE_BROKER_PASSWORD=${MESSAGE_BROKER_PASSWORD} MESSAGE_BROKER_USERNAME=${MESSAGE_BROKER_USERNAME} MESSAGE_BROKER_ADDRESS=${MESSAGE_BROKER_ADDRESS} license_key_acs=${license_key_acs} license_key_ums=${license_key_ums} license_key_cwmp=${license_key_cwmp} version_dx=${version_dx} region_id_acs=${region_id_acs}"