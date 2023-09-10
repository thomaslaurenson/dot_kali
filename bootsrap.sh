#!/bin/bash

# Set colors
RED="\033[0;31m"
NC="\033[0m"

##### Add .aliases file ~/.zshrc
echo -e "${RED}[+] Loading .aliases into ~/.zshrc file...${NC}"
if ! grep dot_kali ~/.zshrc > /dev/null; then
    echo -e "\n# load .aliases file" >> ~/.zshrc
    echo -e "\nif [ -f ~/dot_kali/.aliases ]; then" >> ~/.zshrc
    echo -e "    . ~/dot_kali/.aliases" >> ~/.zshrc
    echo -e "fi" >> ~/.zshrc
fi

# Add user to Virtual Box shared folder group
echo -e "${RED}[+] Adding user to vboxsf group...${NC}"
if ! getent group vboxsf > /dev/null; then
    sudo usermod -a -G vboxsf $(whoami)
fi

##### Install packages
packagelist=(
    # Pentest tools
    seclists
    feroxbuster
    gobuster
    testssl.sh
    # Screenshot
    ksnip
    # Python
    python3-pip
    python3-venv
)

echo -e "${RED}[+] Installing required package...${NC}"
sudo apt-get -y install ${packagelist[@]}

##### Impacket (requires python3-pip)
echo -e "${RED}[+] Installing impacket...${NC}"
if [[ ! -d /opt/impacket ]]; then
    sudo git clone https://github.com/SecureAuthCorp/impacket.git /opt/impacket
    cd /opt/impacket
    sudo pip3 install -r requirements.txt
    sudo python3 setup.py install
fi

##### Docker
echo -e "${RED}[+] Installing Docker...${NC}"
sudo apt -y install docker.io
sudo systemctl enable docker --now

# Add user to Docker group
if ! getent group docker > /dev/null; then
    sudo usermod -a -G docker $(whoami)
fi

##### VS Code
echo -e "${RED}[+] Installing Visual Studio Code...${NC}"
if ! command -v code &> /dev/null; then
    sudo apt-get install wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt-get -y install apt-transport-https
    sudo apt-get -y update
    sudo apt-get -y install code
fi

# Decompress rockyou
if [[ ! -f /usr/share/wordlists/rockyou.txt ]]; then
    cd /usr/share/wordlists
    sudo gunzip rockyou.txt.gz
fi

# Remove any unused packages
sudo apt-get -y autoremove
