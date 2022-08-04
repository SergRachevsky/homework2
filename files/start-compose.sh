#!/bin/sh

cd /opt/teamcity-agents

# Allow 'ubuntu' user to run docker without 'sudo'
echo "=1======================================"
id -nG
# sudo groupadd docker
id -nG
sudo usermod -aG docker ubuntu
id -nG
newgrp docker
id -nG
echo 'ubuntu' | sudo -S -u ubuntu id -nG
echo "=2======================================"
echo 'ubuntu' | sudo -S -u ubuntu docker pull jetbrains/teamcity-agent
echo "=3======================================"
echo 'ubuntu' | sudo -S -u ubuntu docker-compose up -d
echo "=4======================================"
