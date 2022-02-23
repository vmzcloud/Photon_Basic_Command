# Photon Basic Command

<font color=#0000FF>**Set hostname**</font>

    hostnamectl set-hostname Photon01

<font color=#0000FF>**Configure Network**</font>

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

<font color=#0000FF>**Set timezone (Hong Kong)**</font>

    ln -sf /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime