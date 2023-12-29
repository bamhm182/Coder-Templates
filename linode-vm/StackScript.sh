#!/usr/bin/env sh

mkdir -p /home/${username}
sudo file -s /dev/sdb | grep ext4 || mkfs.ext4 /dev/sdb
uuid=$(blkid | awk '/^\/dev\/sdb/ {print $2}')
grep "/home/${username}" /etc/fstab || (echo "$uuid /home/${username} ext4 defaults 0 2" >> /etc/fstab)
mount -a

useradd -Md '/home/${username}' -p '${password_hash}' -s /bin/bash ${username}
cp -rp /etc/skel/.[a-zA=Z]* /home/${username}
mkdir -p '/home/${username}/.ssh'
mv /root/.ssh/authorized_keys /home/${username}/.ssh/authorized_keys
chown ${username}:${username} /home/${username} -R

echo "${username} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${username}
chmod 0400 /etc/sudoers.d/${username}

passwd --lock root

hostnamectl set-hostname ${hostname}

mkdir -p /opt/coder

echo ${init_script} | base64 -d > /opt/coder/init

chmod 0755 /opt/coder/init

cat <<EOF > /etc/systemd/system/coder-agent.service
[Unit]
Description=Coder Agent
After=network-online.target
Wants=network-online.target

[Service]
User=${username}
ExecStart=/opt/coder/init
Environment=CODER_AGENT_TOKEN=${coder_agent_token}
Restart=always
RestartSec=10
TimeoutStopSec=90
KillMode=process

OOMScoreAdjust=-900
SyslogIdentifier=coder-agent

[Install]
WantedBy=multi-user.target
EOF

chmod 0644 /etc/systemd/system/coder-agent.service

systemctl daemon-reload
systemctl enable --now coder-agent.service

rm /root/StackScript
