#!/bin/sh -xe

useradd -r -U -m -s /bin/bash -p '*' -c "Git Service" git
echo '\nPermitUserEnvironment yes' >>/etc/ssh/sshd_config
wget -O /tmp/gogs.zip https://github.com/gogits/gogs/releases/download/v0.5.11/linux_amd64.zip
mkdir -p /opt
cd /opt
unzip -q /tmp/gogs.zip
rm /tmp/gogs.zip
