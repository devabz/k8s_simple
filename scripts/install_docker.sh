#!/bin/bash

# Update package repo
apt-get update -y

# Prerequisites
apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y

# Add Docker GPG keys
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker- archive-keyring.gpg

# Add Docker rep to apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg]     https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >    /dev/null

# Update again
apt-get update -y

# Install Docker
apt-get install docker-ce docker-ce-cli containerd.io -y

# Update docker daemon
cp scripts/daemon.json /etc/docker/daemon.json

# Enable start on boot 
systemctl enable docker

# Reload Docker Daemon
systemctl daemon-reload
systemctl restart docker

# Print verson
docker --version