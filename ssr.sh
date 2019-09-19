#!/bin/bash
# Description: config ssr

### clone shadowsocksr
git clone --branch akkariiin/master https://github.com/shadowsocksrr/shadowsocksr.git

### init config
cd shadowsocksr
bash initcfg.sh

### modify config.json
cat > user-config.json <<-EOF
{
    "server": "0.0.0.0",
    "server_ipv6": "::",
    "server_port": 8388,
    "local_address": "127.0.0.1",
    "local_port": 1080,

    "password": "yujinsheng",
    "method": "aes-128-ctr",
    "protocol": "auth_aes128_md5",
    "protocol_param": "",
    "obfs": "tls1.2_ticket_auth_compatible",
    "obfs_param": "",
    "speed_limit_per_con": 0,
    "speed_limit_per_user": 0,

    "additional_ports" : {}, // only works under multi-user mode
    "additional_ports_only" : false, // only works under multi-user mode
    "timeout": 120,
    "udp_timeout": 60,
    "dns_ipv6": false,
    "connect_verbose_info": 0,
    "redirect": "",
    "fast_open": false
}
EOF

### systemd service
mkdir -p ~/.config/systemd/user
cd ~/.config/systemd/user
cat > shadowsocksr.service <<-EOF
[Unit]
Description=Shadowsocks R Server Service
After=default.target

[Service]
WorkingDirectory=/root/shadowsocksr/shadowsocks
ExecStart=/usr/bin/python3 server.py -c /root/shadowsocksr/user-config.json
Restart=on-abort

[Install]
WantedBy=default.target
EOF

### reload and start service
systemctl --user daemon-reload
systemctl --user start shadowsocksr
systemctl --user status shadowsocksr
