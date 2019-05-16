FROM ubuntu:18.04
MAINTAINER Pocteo Factory "https://github.com/pocteo"
USER root
RUN \
  apt-get update && \
  apt-get install -y software-properties-common && \
  apt-add-repository ppa:ansible/ansible && \
  apt-get update && \
  apt-get install -y --force-yes ansible
 
RUN mkdir /ansible
##############
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin
################
VOLUME /root/.kube/config   /usr/local/bin/kubectl
RUN add-apt-repository ppa:webupd8team/java
RUN apt install oracle-java8-installer
RUN apt install oracle-java8-set-default
#############
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

CMD  ["/usr/sbin/sshd", "-D"]