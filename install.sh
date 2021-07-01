#!/bin/bash
# sleep until instance is ready
#3until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
 # sleep 1
#done
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'
sudo apt-get update -y
sudo apt-cache policy docker-ce
sudo apt-get install docker-ce -y
sudo service docker start
sudo apt install wget -y
sudo apt install openjdk-8-jdk -y
sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt install jenkins -y
sudo systemctl start jenkins 


cd /home/ubuntu
mkdir nginx-deployment
cd nginx-deployment
touch Dockerfile
echo "FROM nginx:latest" >> Dockerfile
docker build --tag website:latest .
docker run --name website -p 80:80 -d website:latest
