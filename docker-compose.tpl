#cloud-config
write_files:
 - content: |
        version: '3'
        services:
            alpine:
              image: alpine:latest
   path: /opt/docker-compose.yml
runcmd:
 - #!/bin/sh
 - sudo yum update -y
 - sudo yum install -y docker
 - sudo chmod +x /usr/local/bin/docker-compose
 - sudo systemctl start docker
 - sudo systemctl enable docker
 - sudo chkconfig docker on
 - sudo docker-compose -f /opt/docker-compose.yml up -d
