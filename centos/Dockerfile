FROM centos:7
MAINTAINER Zenoss, Inc <dev@zenoss.com> 

# build ssh dependencies
RUN yum install -y openssh-server 

RUN mkdir -p /var/run/sshd ; chmod -rx /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
#RUN su - root -c "mkdir -p ~/.ssh && ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '' && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && echo StrictHostKeyChecking no >> /etc/ssh/ssh_config"
CMD ["/usr/sbin/sshd", "-D"]

