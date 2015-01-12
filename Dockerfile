FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8

#Runit
RUN apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common

#Etcd
RUN curl -L https://github.com/coreos/etcd/releases/download/v0.4.6/etcd-v0.4.6-linux-amd64.tar.gz | tar zx
RUN mv /etcd* /etcd && \
    ln -s /etcd/etcd /usr/local/bin/etcd && \
    ln -s /etcd/etcdctl /usr/local/bin/etcdctl

#Kubernetes
RUN curl -L https://github.com/GoogleCloudPlatform/kubernetes/releases/download/v0.8.0/kubernetes.tar.gz | tar zx
RUN tar -xvf /kubernetes/server/kubernetes-server-linux-amd64.tar.gz --strip-components 3 -C /usr/local/bin 

#Aliases
ADD aliases /root/.aliases
RUN echo "source ~/.aliases" >> /root/.bashrc

#Add runit services
ADD sv /etc/service 
