#!/bin/sh

sudo apt update
sudo apt upgrade -y

sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    mc \
    python3-pip

python3 -m pip install --upgrade pip wheel setuptools
