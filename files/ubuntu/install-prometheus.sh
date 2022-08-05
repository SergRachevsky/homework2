#!/bin/sh

PROMETHEUS=node_exporter-1.3.1.linux-amd64



# Download and move the node exporter binary to /usr/local/bin
cd /var/tmp

wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/${PROMETHEUS}.tar.gz
tar xvfz ${PROMETHEUS}.tar.gz
sudo mv ${PROMETHEUS}/node_exporter /usr/local/bin/


# sudo rm ${PROMETHEUS}.tar.gz
# sudo mv ${PROMETHEUS} prometheus
# sudo chmod -R a+rw /opt/prometheus

# Create a node_exporter user to run the node exporter service.
sudo useradd -rs /bin/false node_exporter

# Create a node_exporter service file under systemd.
sudo tee /etc/systemd/system/node_exporter.service<<EOF
[Unit]
Description=Node Exporter
After=network.target
 
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
 
[Install]
WantedBy=multi-user.target
EOF

# Reload the system daemon and start the node exporter service.
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

