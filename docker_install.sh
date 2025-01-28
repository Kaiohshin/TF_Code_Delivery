#!/bin/sh
sudo yum update -y
sudo yum install -y docker
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo chkconfig docker on
sudo docker-compose up -f docker-compose.yml