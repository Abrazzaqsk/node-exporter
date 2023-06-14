#!/bin/bash

# Download the Node Exporter
VERSION="1.2.2"
wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz

# Extract the tarball
tar xvfz node_exporter-${VERSION}.linux-amd64.tar.gz

# Move the binary to /usr/local/bin
sudo mv node_exporter-${VERSION}.linux-amd64/node_exporter /usr/local/bin/

# Create a dedicated system user for Node Exporter
sudo useradd --no-create-home --shell /bin/false node_exporter

# Create a systemd service file
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOL
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOL

# Enable and start the Node Exporter service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
