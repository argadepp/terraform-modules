#!/bin/bash
# Update and install necessary packages
apt-get update -y
apt-get install -y nfs-common openjdk-11-jre-headless
# Create Jenkins data directory and mount EFS
mkdir -p /var/lib/jenkins
echo "${aws_efs_file_system.jenkins_efs.id}:/ /var/lib/jenkins nfs4 defaults,_netdev 0 0" >> /etc/fstab
mount -a
# Set permissions for Jenkins to access the mounted directory
chown -R jenkins:jenkins /var/lib/jenkins
# Add Jenkins repository and key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
# Start and enable Jenkins service
systemctl start jenkins
systemctl enable jenkins
echo "Jenkins setup complete with shared EFS volume."