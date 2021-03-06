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

## **Install docker-compose**

    curl -L https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

    chmod +x /usr/local/bin/docker-compose

## **Start and Enable docker service**

    #Start docker and enable it to be started at boot time
    systemctl start docker
    systemctl enable docker

## **Enable Docker Remote API**

    chmod +x Enable-DockerRemoteAPI.sh
    ./Enable-DockerRemoteAPI.sh

## **Enable Ping**

    iptables -A OUTPUT -p icmp -j ACCEPT
    iptables -A INPUT -p icmp -j ACCEPT