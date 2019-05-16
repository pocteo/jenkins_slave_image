FROM ubuntu:18.04
MAINTAINER Pocteo Factory "https://github.com/pocteo"

RUN \
  apt-get update && \
  apt-get install -y software-properties-common && \
  apt-add-repository ppa:ansible/ansible && \
  apt-get update && \
  apt-get install -y --force-yes ansible


RUN \
  apt-get update && \
  apt-get install -y curl && \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.14.0/bin/darwin/amd64/kubectl && \
  chmod +x ./kubectl && \
  mv ./kubectl /usr/local/bin/kubectl
RUN mkdir .kube
COPY  config  .kube/config

RUN apt-get update && apt-get install -y openjdk-8-jdk

# install ansible
# install kubectl
# copy k8s cluster config to ~/.kube
# install java8

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





