#!/bin/bash -xe

#remove node_exporter
yum remove node_exporter.x86_64
#Create User
adduser --no-create-home --shell /bin/false node_exporter
#Download Binary
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
#Untar
tar xvzf node_exporter-1.0.1.linux-amd64.tar.gz
#Copy Exporter
cp node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/
#Assign Ownership Again
chown node_exporter:node_exporter /usr/local/bin/node_exporter
#Creating Service File
cat <<- EOF >  /etc/systemd/system/node_exporter.service
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
WantedBy=multi-user.target
EOF

export LC_ALL=en_US.UTF-8;
export LANG=en_US.UTF-8;
systemctl daemon-reload;
systemctl enable node_exporter
systemctl start node_exporter
systemctl status node_exporter
