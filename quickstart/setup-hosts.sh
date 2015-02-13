#!/bin/bash

if [[ $# -lt 3 ]]; then
    echo must specify at least three nodes
    echo "USAGE: $0 nodes..."
    echo "    example: $0 ceph01 ceph02 ceph03"
    exit 1
fi

HOSTS="$@"

CEPH_MON_HOST="$1"
shift
CEPH_OSD_HOSTS="$@"

# retrieve ips for all mons and OSDs
entries=
for host in $HOSTS; do
    ip=$(getent ahostsv4 $host|awk '{print $1;exit 0}')
    if [[ -z $ip ]]; then
        echo "unable to get ip for host: $host"
        exit 2
    fi
    entries="$entries\n$ip $host"
done

# update all OSDs
for host in $CEPH_OSD_HOSTS; do
    ssh $host "echo -e '$entries' >>/etc/hosts"
done


