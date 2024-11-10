#!/bin/bash

# Update package index
sudo apt-get update

# Install Java (OpenJDK 17, required for Jenkins)
sudo apt-get install -y openjdk-17-jdk

# Add Jenkins repository key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository to the sources list
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package index with the new repository
sudo apt-get update

# Install Jenkins
sudo apt-get install -y jenkins

# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

echo "Jenkins installation completed. Access it at http://<your-server-ip>:8080"
