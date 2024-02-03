#!/bin/bash

KUBERNETES_VERSION=1.29

GREEN= '\033[0;32m'

# Remove unofficial docker installations
echo "Removing unofficial docker installations"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc;
do apt-get remove $pkg;
done

# Docker installation
echo -e "${GREEN}---------------------Starting docker installation..."
apt-get update
apt-get -y install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo -e "${GREEN}---------------------Finished docker installation."

# Virtualbox installation
echo -e "${GREEN}---------------------Starting virtualbox installation"
apt update
apt -y install virtualbox
echo -e "${GREEN}---------------------Finished virtualbox installation"

# Vagrant installation
echo -e "${GREEN}---------------------Starting vagrant installation"
apt update
apt -y install vagrant
echo -e "${GREEN}---------------------Finished vagrant installation"

# Magma dependencies installation
echo -e "${GREEN}---------------------Starting Magma dependencies installation"

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
chmod a+x ./aws/install
sudo ./aws/install

apt-get update
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_VERSION/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubectl

curl https://baltocdn.com/helm/signing.asc | gpg -o --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install -y helm

apt-get update
apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg -o --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
tee /etc/apt/sources.list.d/hashicorp.list
apt update
apt-get -y install terraform

echo -e "${GREEN}---------------------Dependencies Installation finished successfully."
