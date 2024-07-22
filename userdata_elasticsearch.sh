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

IP1=`aws ec2 describe-instances --filters "Name=tag:Name,Values=${elastic_1}" "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[PrivateDnsName]' --output text | cut -d"." -f1`
IP2=`aws ec2 describe-instances --filters "Name=tag:Name,Values=${elastic_2}" "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[PrivateDnsName]' --output text | cut -d"." -f1`
IP3=`aws ec2 describe-instances --filters "Name=tag:Name,Values=${elastic_3}" "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[PrivateDnsName]' --output text | cut -d"." -f1`

echo "${key_elastic_1}" > elastic1.pem
echo "${key_elastic_2}" > elastic2.pem
echo "${key_elastic_3}" > elastic3.pem

chmod 400 *.pem

sleep 5

echo "
[master]
$IP1 ansible_ssh_private_key_file=/elastic1.pem
[nodes]
$IP2 ansible_ssh_private_key_file=/elastic2.pem
$IP3 ansible_ssh_private_key_file=/elastic3.pem
[all:vars]
ansible_user=${user}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee hosts

echo "
- name: Applying installation and dependency 
  hosts: all
  become: yes
  vars:
    elastic_version: ${version_elastic}
    nodes_address: 
       - $IP1
       - $IP2
       - $IP3

  roles:
   - elasticsearch" > playbook.yaml
       

sleep 5
ansible-playbook -i hosts playbook.yaml