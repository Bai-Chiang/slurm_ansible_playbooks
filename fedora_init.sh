#!/usr/bin/bash

dnf install -y policycoreutils-python-utils

# set ssh port
echo "ssh port? (22)"
read ssh_port
ssh_port="${ssh_port:-22}"
if [[ $ssh_port -ne 22 ]] ; then
    sed -i "s/^#Port.*/Port ${ssh_port}/" /etc/ssh/sshd_config
    semanage port -a -t ssh_port_t -p tcp $ssh_port
    sed "/port=/s/port=\"22\"/port=\"${ssh_port}\"/" /usr/lib/firewalld/services/ssh.xml  > /etc/firewalld/services/ssh.xml
    firewall-cmd --reload
fi

echo -e "\n\n"
ip address show scope global
echo -e "\n\n"

echo "Type a interface name that you want to set to trusted zone (empty to skip)"
read trusted_interface
if [[ -n $trusted_interface ]] ; then
    firewall-cmd --permanent --zone=trusted --change-interface="$trusted_interface"
    firewall-cmd --reload
fi

echo "Type a interface name that you want to set to external zone (empty to skip)"
read external_interface
if [[ -n $external_interface ]] ; then
    firewall-cmd --permanent --zone=external --change-interface="$external_interface"
    firewall-cmd --permanent --new-policy NAT_trust_to_ext
    firewall-cmd --permanent --policy NAT_trust_to_ext --add-ingress-zone trusted
    firewall-cmd --permanent --policy NAT_trust_to_ext --add-egress-zone external
    firewall-cmd --permanent --policy NAT_trust_to_ext --set-target ACCEPT
    firewall-cmd --reload
fi

