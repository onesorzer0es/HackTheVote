#!/bin/sh

set -e

sudo apt update
sudo apt upgrade
sudo apt install socat

groupadd -g 1337 app
useradd -g app -u 1337 app -s /bin/bash

cat > /etc/systemd/system/votingbooth.service <<EOF
[Unit]
Description=votingbooth
After=network.target

[Service]
Type=simple
User=app
WorkingDirectory=/server
ExecStart=/server/server.sh
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

mv src/server /server
rm -r src
chown root:app -R /server/*

systemctl daemon-reload
systemctl enable votingbooth
systemctl start votingbooth
