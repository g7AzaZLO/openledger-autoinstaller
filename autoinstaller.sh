#!/bin/bash

# Первоначальная настройка сервера
. <(wget -qO- https://raw.githubusercontent.com/g7AzaZLO/server_primary_setting/refs/heads/main/server_primary_setting)

# Установка необходимых пакетов

sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu jammy main universe"
sudo apt-get install -y libasound2=1.2.6.1-1ubuntu1 libasound2-data=1.2.6.1-1ubuntu1
sudo apt install -y libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libsecret-1-0 desktop-file-utils libgbm1

wget http://archive.ubuntu.com/ubuntu/pool/main/a/at-spi2-core/libatspi2.0-0_2.44.1-0ubuntu2_amd64.deb
sudo dpkg -i libatspi2.0-0_2.44.1-0ubuntu2_amd64.deb
sudo apt-get install -f

# Скачивание и распаковка OpenLedger Node
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
unzip openledger-node-1.0.0-linux.zip

# Установка deb-пакета
sudo dpkg -i openledger-node-1.0.0.deb
sudo apt-get install -f
sudo dpkg --configure -a

# Обновление конфигурации SSH
SSH_CONFIG="/etc/ssh/sshd_config"

if grep -q "#X11Forwarding yes" "$SSH_CONFIG" || grep -q "#X11DisplayOffset 10" "$SSH_CONFIG" || grep -q "#X11UseLocalhost yes" "$SSH_CONFIG"; then
    sudo sed -i 's/#X11Forwarding yes/X11Forwarding yes/' "$SSH_CONFIG"
    sudo sed -i 's/#X11DisplayOffset 10/X11DisplayOffset 10/' "$SSH_CONFIG"
    sudo sed -i 's/#X11UseLocalhost yes/X11UseLocalhost yes/' "$SSH_CONFIG"
fi

# Перезапуск или запуск службы SSH
if systemctl is-active --quiet sshd; then
    sudo systemctl restart sshd
else
    sudo systemctl start ssh
fi

# Запуск OpenLedger Node
openledger-node --no-sandbox
