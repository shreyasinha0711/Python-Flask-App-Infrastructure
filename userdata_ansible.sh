#!/bin/bash
sudo apt update
sudo apt install ansible -y
sudo apt install docker.io -y
sudo usermod -a -G docker ubuntu
sudo chmod 666 /var/run/docker.sock
sudo service docker restart
sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
echo "done"