#!/bin/bash
set -e

# Update and install Docker
yum update -y
amazon-linux-extras install docker -y
service docker start
systemctl enable docker
usermod -a -G docker ec2-user

# Install docker-compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install CloudWatch agent
yum install -y amazon-cloudwatch-agent

# Install Certbot (for HTTPS later, run manually once domain/EIP is set)
amazon-linux-extras install epel -y
yum install -y certbot python3-certbot-nginx nginx

# Placeholder: app will be deployed by CI/CD (Jenkins) via SSH/Docker
mkdir -p /opt/app
echo "EC2 bootstrap complete" > /opt/app/bootstrap.log
