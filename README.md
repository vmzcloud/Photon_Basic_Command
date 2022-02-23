# Photon Basic Command

<span style="color: blue;">**Set hostname**</span>

    hostnamectl set-hostname Photon01

<span style="color: blue;">**Configure Network**</span>

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

<span style="color: blue;">**Set timezone (Hong Kong)**</span>

    ln -sf /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime