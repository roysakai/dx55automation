#!/bin/bash
USER='vagrant'
PASS='123'

sudo usermod -p $(openssl passwd -1 ${PASS}) $USER
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo swapoff -a
