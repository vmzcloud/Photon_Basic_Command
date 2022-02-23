# Enable Local/Remote Docker API on PhotonOS

# Prerequisites

# You must have already performed the following in one form or another **as well as properly set a STATIC IP**.  Bear in mind many instructions do not properly show how to commit iptables changes on Photon which then survive reboots.

iptables -A INPUT -p tcp --dport 2375 -j ACCEPT
iptables -A INPUT -p tcp --dport 2376 -j ACCEPT
iptables-save > /etc/systemd/scripts/ip4save
systemctl restart iptables

# Perform (Re)configuration of Docker Daemon (using Proper Local Configs)

systemctl stop docker
systemctl disable docker
# IF NEW, DOCKER.SOCKET WON'T EVEN EXIST YET SO IGNORE ANY ERROR/WARNINGS BUT THIS ENABLES THIS TO 
# BE RERUN LATER IF NEEDED AND DOES NOT HURT TO RERUN OVER ITSELF
systemctl stop docker.socket
systemctl disable docker.socket

# FIX/CREATE LOCAL (NOT LIB COPY AS INCORRECTLY STATED BY OTHERS THAT IS OVERWRITTEN ON UPGRADES!!!
echo '[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target docker.socket
Requires=docker.socket
[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s
[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/docker.service

# FIX/CREATE THE NON-EXISTING DOCKER.SOCKET SERVICE ON PHOTONOS IF UPGRADING FROM DEFAULT DOCKER INSTALL
# AGAIN THIS IS A LOCAL NOT LIB THAT WOULD BE OVERWRITTEN ON UPGRADE
echo '[Unit]
Description=Docker Socket for the API
PartOf=docker.service
[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker
[Install]
WantedBy=sockets.target
' > /etc/systemd/system/docker.socket

# RESTART DOCKER AND TEST VIA SHELL FOR API OUTPUT
systemctl daemon-reload
systemctl enable docker.socket
systemctl enable docker
systemctl start docker
systemctl start docker.socket

# TEST IF WE NOW GET PROPER TCP-BASED API RESPONSE (REMOTE SHOULD NOW WORK TOO)
docker -H tcp://0.0.0.0:2375 ps
