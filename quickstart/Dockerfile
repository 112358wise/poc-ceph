FROM ubuntu:trusty
MAINTAINER Zenoss, Inc <dev@zenoss.com> 

ENV CEPH_STABLE_VERSION firefly

RUN apt-get update -qq

# build dependencies
RUN apt-get install -y -q make curl wget ntp openssh-server screen tmux
RUN wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | apt-key add -
RUN apt-get update && apt-get install -y ceph-deploy


ENV CEPH_USER ceph
RUN useradd -d /home/$CEPH_USER -m $CEPH_USER
RUN echo "$CEPH_USER ALL = (root) NOPASSWD:ALL" > /etc/sudoers.d/$CEPH_USER
RUN chmod 0440 /etc/sudoers.d/$CEPH_USER

RUN su - $CEPH_USER -c "mkdir -p ~/.ssh && ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '' && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

ADD quick-ceph-cluster.sh /quick-ceph-cluster.sh

