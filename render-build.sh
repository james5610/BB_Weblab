#!/bin/bash
# Update the package manager
apt-get update

# Install Python and pip
apt-get install -y python3-pip

# Install Python dependencies
pip3 install -r requirements.txt