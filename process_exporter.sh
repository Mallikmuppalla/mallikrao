sudo useradd --no-create-home --shell /bin/false process_exporter
cd ~
curl -LO https://github.com/ncabatoff/process-exporter/releases/download/v0.5.0/process-exporter-0.5.0.linux-amd64.tar.gz
tar xvf process-exporter-0.5.0.linux-amd64.tar.gz
sudo cp process-exporter-0.5.0.linux-amd64/process-exporter /usr/local/bin
sudo chown process_exporter:process_exporter /usr/local/bin/process-exporter
touch /etc/process_exporter.yml
cat <<EOF > /etc/process_exporter.yml
process_names:
  - name: "{{.Comm}}"
    cmdline:
    - '.+'
EOF
chown process_exporter /etc/process_exporter.yml
sudo touch /etc/systemd/system/process_exporter.service
cat <<EOF > /etc/systemd/system/process_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=process_exporter
Group=process_exporter
Type=simple
ExecStart=/usr/local/bin/process-exporter --config.path /etc/process_exporter.yml

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl start process_exporter
sudo systemctl enable process_exporter
rm -rf process-exporter-0.5.0.linux-amd64.tar.gz process-exporter-0.5.0.linux-amd64
