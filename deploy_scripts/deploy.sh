#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

#Variables
ansible="s3://sandbox-demo-artifact-repository/vip-app-ansible-307701345.zip"
playbook="frontend"

#Install Ansible
yum -y install epel-release
yum -y install ansible
yum -y install unzip
yum -y install jq

# Read Artifact URL out of tag
app=$(/usr/local/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" "Name=key,Values=Artifact" | jq -r .Tags[0].Value)


#Download S3 artifact for ansible role and unpack it
/usr/local/bin/aws s3 cp $ansible /tmp/ansible.zip
cd /tmp
unzip /tmp/ansible.zip 

#Run ansible
ansible-playbook /tmp/ansible/${playbook}.yml -e artifact_url=${app}
