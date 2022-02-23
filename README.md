# Photon Basic Command

## **Default login password for Photon OVA**

root / changeme

## **Set hostname**

    hostnamectl set-hostname Photon01

## **Configure Network**

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

## **Set timezone (Hong Kong)**

    ln -sf /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime

## **Disable password aging for root user (Optional)**

    # -I Set password inactive after expiration to INACTIVE
    # -m Set minimum number of days before password change to MIN_DAYS
    # -M Set maximum number of days before password change to MAX_DAYS
    # -E Set account expiration date to EXPIRE_DATE

    chage -I -1 -m 0 -M 99999 -E -1 root