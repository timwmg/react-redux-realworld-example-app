#!/bin/bash

#Variables
ansible="s3://sandbox-demo-artifact-repository/vip-app-ansible-307701345.zip"
playbook="frontend"
app="s3://sandbox-demo-artifact-repository/react-redux-realworld-example-app-303550420.zip"

#Install Ansible
yum -y install epel-release
yum -y install ansible
yum -y install unzip

#Download S3 artifact for ansible role and unpack it
/usr/local/bin/aws s3 cp $ansible /tmp/ansible.zip
cd /tmp
unzip /tmp/ansible.zip 

#Run ansible
ansible-playbook /tmp/ansible/${playbook}.yml -e artifact_url=${app}
