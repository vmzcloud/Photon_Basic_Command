# Photon Basic Command

**Set hostname**

    hostnamectl set-hostname Photon01

**Configure Network**

Create the network configuration file


    cat > /etc/systemd/network/10-static-en.network << "EOF"

    [Match]
    Name=eth0

    [Network]
    Address=198.51.0.2/24
    Gateway=198.51.0.1
    DNS=192.51.0.1
    EOF

Change network configuration file permission

    chmod 644 /etc/systemd/network/10-static-en.network

Restart network service

    systemctl restart systemd-networkd