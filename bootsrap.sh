#!/bin/bash

# Add .aliases file to ZSH
echo "# load .aliases file" >> ~/.zshrc
echo "\nif [ -f ~/.aliases ]; then" >> ~/.zshrc
echo "    . ~/.aliases" >> ~/.zshrc
echo "fi" >> ~/.zshrc

# Add user to Virtual Box shared folder group
sudo usermod -a -G vboxsf $(whoami)

# Install packages
sudo apt -y install seclists
sudo apt -y install feroxbuster
sudo apt -y install ksnip
sudo apt -y install gobsuter

# Python
sudo apt -y install python3-pip
sudo apt -y install python3-venv

# Impacket
# sudo apt install python3-pip
sudo git clone https://github.com/SecureAuthCorp/impacket.git /opt/impacket
cd /opt/impacket
sudo pip3 install -r requirements.txt
sudo python3 setup.py install

# Docker
sudo apt -y install docker
sudo apt -y install docker-compose
sudo usermod -a -G docker $(whoami)
