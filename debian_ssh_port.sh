#!/usr/bin/bash

apt update
apt dist-upgrade

# install firewalld
apt install firewalld

# set ssh port
echo "ssh port? (22)"
read ssh_port
ssh_port="${ssh_port:-22}"
if [[ $ssh_port -ne 22 ]] ; then
    sed -i "s/^#Port.*/Port ${ssh_port}/" /etc/ssh/sshd_config
    sed "/port=/s/port=\"22\"/port=\"${ssh_port}\"/" /usr/lib/firewalld/services/ssh.xml  > /etc/firewalld/services/ssh.xml
    firewall-cmd --reload
fi

