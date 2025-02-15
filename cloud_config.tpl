#cloud-config
write_files:
 - content: |
        version: '3'
        services:
            alpine:
              image: ${ALPINE_IMAGE}
              ports: 
                - 3000:3000
   path: /opt/docker-compose.yml
runcmd:
 - sudo yum update -y
 - sudo yum install -y docker
 - sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
 - sudo chmod +x /usr/local/bin/docker-compose
 - sudo systemctl start docker
 - sudo systemctl enable docker
 - sudo usermod -a -G docker ec2-user 
 - sudo chkconfig docker on
 - sudo chown $(whoami):$(whoami) /var/run/docker.sock
 - aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_URL}
 - docker-compose -f /opt/docker-compose.yml up -d
