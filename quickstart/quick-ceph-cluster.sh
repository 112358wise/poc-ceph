#!/bin/bash

if [[ $# -lt 3 ]]; then
    echo must specify at least three nodes
    echo "USAGE: $0 nodes..."
    echo "    example: $0 ceph01 ceph02 ceph03"
    exit 1
fi


CEPH_ADM_HOST=$(hostname -s)
CEPH_MON_HOST="$1"
shift
CEPH_OSD_HOSTS="$@"

mkdir ~/my-cluster
cd ~/my-cluster

# create the cluster
ceph-deploy new $CEPH_MON_HOST

# reduce pool size from 3 to 2
sed -i.old -e 's/\(\[global\]\)/\1\nosd pool default size = 2/' ceph.conf

# Install Ceph
ceph-deploy install $CEPH_ADM_HOST $CEPH_OSD_HOSTS

ceph-deploy mon create-initial

ceph-deploy mon create $CEPH_MON_HOST

ceph-deploy gatherkeys $CEPH_MON_HOST

MOUNT=/var/lib/docker
for node in $CEPH_OSD_HOSTS; do
    ceph-deploy osd prepare $node:$MOUNT
done

for node in $CEPH_OSD_HOSTS; do
    ceph-deploy osd activate $node:$MOUNT
done

ceph-deploy admin $CEPH_ADM_HOST $CEPH_MON_HOST $CEPH_OSD_HOSTS

sudo chmod +r /etc/ceph/ceph.client.admin.keyring

ceph-deploy gatherkeys $CEPH_ADM_HOST $CEPH_MON_HOST $CEPH_OSD_HOSTS

echo "check health with:"
echo "    ceph health"


