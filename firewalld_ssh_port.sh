#!/usr/bin/bash

# Install firewalld
if [[ -e /usr/bin/pacman ]] ; then
    pacman -Syu
    pacman -S --needed firewalld
elif [[ -e /usr/bin/dnf ]] ; then
    dnf update
    dnf install firewalld
elif [[ -e /usr/bin/apt ]] ; then
    apt update
    apt dist-upgrade
    apt install firewalld
fi

read -p "Is this login node? [y/n] " login_node
login_node="${login_node,,}"

if [[ $login_node == y ]] ; then
    ip address show scope global
    echo -e "\nSet any interface to External firewall zone that only allow ssh connection?\nType interface name:"
    read ext_interface
    firewall-cmd --permanent --zone=external --change-interface=${ext_interface}
    firewall-cmd --permanent --new-policy trust_to_external
    firewall-cmd --permanent --policy trust_to_external --add-ingress-zone trusted
    firewall-cmd --permanent --policy trust_to_external --add-egress-zone external
    firewall-cmd --permanent --policy trust_to_external --set-target ACCEPT
fi

ip address show scope global
echo -e "\nSet any interface to Trusted firewall zone for internal connection? Type interface name:"
read trust_interface
if [[ -n $trust_interface ]] ; then
    firewall-cmd --permanent --zone=trusted --change-interface=${trust_interface}
fi

# set ssh port
echo "ssh port? (22)"
read ssh_port
ssh_port="${ssh_port:-22}"
if [[ $ssh_port -ne 22 ]] ; then
    sed -i "s/^#Port.*/Port ${ssh_port}/" /etc/ssh/sshd_config
    sed "/port=/s/port=\"22\"/port=\"${ssh_port}\"/" /usr/lib/firewalld/services/ssh.xml  > /etc/firewalld/services/ssh.xml
fi

if [[ $ssh_port -ne 22 && -e /usr/bin/sestatus ]] ; then
    dnf install -y policycoreutils-python-utils
    echo "Change ssh_port_t on SELinux system."
    semanage port -a -t ssh_port_t -p tcp $ssh_port
    firewall-cmd --reload
fi

firewall-cmd --reload

