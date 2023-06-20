#!/usr/bin/bash

# set ssh port
echo "ssh port? (22)"
read ssh_port
ssh_port="${ssh_port:-22}"

if [[ $ssh_port -ne 22 ]] ; then
    sed -i "s/^#Port.*/Port ${ssh_port}/" /etc/ssh/sshd_config
    echo "Modify default firewalld ssh service with new port."
    sed "/port=/s/port=\"22\"/port=\"${ssh_port}\"/" /usr/lib/firewalld/services/ssh.xml  > /etc/firewalld/services/ssh.xml
    firewall-cmd --reload
fi

if [[ $ssh_port -ne 22 && -e /usr/bin/sestatus ]] ; then
    dnf install -y policycoreutils-python-utils
    echo "Change ssh_port_t on SELinux system."
    semanage port -a -t ssh_port_t -p tcp $ssh_port
    firewall-cmd --reload
fi

