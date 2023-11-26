#!/usr/bin/sh


# Set colors
RED=$(tput setaf 1)
NORMAL=$(tput sgr0)

# Aliases URL
aliases_url="https://github.com/thomaslaurenson/dot_kali/releases/latest/download/aliases"

##### Add aliases file ~/.zshrc
printf "%s[+] Configuring aliases...%s\n" "$RED" "$NORMAL"
if [ ! -f "$HOME/.aliases" ]; then
    wget $aliases_url -O "$HOME/.aliases"
fi

if ! grep -q 'dot_kali' "$HOME/.zshrc"; then
    {
        printf "\n# Load dot_kali aliases...\n"
        printf "if [ -f '~/.aliases' ]; then\n"
        printf "    . ~/aliases\n"
        printf "fi\n"
    } >> "$HOME/.zshrc"
fi

# Add user to Virtual Box shared folder group
printf "%s[+] Adding user to vboxsf group...%s\n" "$RED" "$NORMAL"
if ! getent group vboxsf > /dev/null; then
    sudo usermod -a -G vboxsf "$(whoami)"
fi

##### Install packages
packages_list="
seclists
feroxbuster
gobuster
python3-pip
python3-venv
testssl.sh
ksnip
"

packages=$(echo "$packages_list" | tr '\n' ' ')
printf "%s[+] Installing required packages...%s\n" "$RED" "$NORMAL"
sudo apt install -y "$packages"

##### Impacket (requires python3-pip)
printf "%s[+] Installing impacket...%s\n" "$RED" "$NORMAL"
if [ ! -d /opt/impacket ]; then
    sudo git clone https://github.com/SecureAuthCorp/impacket.git /opt/impacket
    cd /opt/impacket || exit 1
    sudo pip3 install -r requirements.txt
    sudo python3 setup.py install
fi

##### Docker
printf "%s[+] Installing Docker...%s\n" "$RED" "$NORMAL"
sudo apt -y install docker.io
sudo systemctl enable docker --now

# Add user to Docker group
if ! getent group docker; then
    sudo usermod -a -G docker "$(whoami)"
fi

##### VS Code
printf "%s[+] Installing VSCode...%s\n" "$RED" "$NORMAL"
if ! command -v code; then
    sudo apt-get -y install wget gpg apt-transport-https
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt-get -y update
    sudo apt-get -y install code
fi

# Decompress rockyou
printf "%s[+] Decompressing rockyou...%s\n" "$RED" "$NORMAL"
if [ ! -f /usr/share/wordlists/rockyou.txt ]; then
    cd /usr/share/wordlists || exit 1
    sudo gunzip rockyou.txt.gz
fi

# Remove any unused packages
sudo apt-get -y autoremove
