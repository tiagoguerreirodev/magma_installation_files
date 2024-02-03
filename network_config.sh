 echo -e "${GREEN}---------------------Starting network configuration..."
# Network Configuration
apt update
apt install -y ifupdown

apt purge netplan.io
rm -rf /usr/share/netplan
rm -rf /etc/netplan

mv -f ./interfaces /etc/network/interfaces

# TODO: Mudanças sugeridas do comando 'man 5 interfaces'

systemctl restart networking

echo -e "${GREEN}---------------------Finished network configuration."
