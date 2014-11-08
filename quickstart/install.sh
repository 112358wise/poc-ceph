#!/bin/bash

export CEPH_STABLE_VERSION=firefly

apt-get update -qq

# build dependencies
apt-get install -y -q make curl wget ntp openssh-server screen tmux
wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | apt-key add -
apt-get update && apt-get install -y ceph-deploy

#export CEPH_USER=ceph
#useradd -d /home/$CEPH_USER -m $CEPH_USER
#echo "$CEPH_USER ALL = (root) NOPASSWD:ALL" > /etc/sudoers.d/$CEPH_USER
#chmod 0440 /etc/sudoers.d/$CEPH_USER

#su - $CEPH_USER -c "mkdir -p ~/.ssh && ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"

#tar -C ~zenoss -czf - .ssh/ | su - $CEPH_USER -c "tar -C ~ -xzf -"


