#!/bin/bash
cd /opt
yum install ansible -y
cd /tmp
git clone https://github.com/Mygit-Naresh/roboshop-ansible-roles.git
cd roboshop-ansible-roles
components=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "cart" "user" "payment" "shipping" "web")
for component in "${components[@]}"; do
    ansible-playbook -e ansible_user=centos -e ansible_password=DevOps321 -e component="$component" super_main.yml
done



