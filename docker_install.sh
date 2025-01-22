#!/bin/sh
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker