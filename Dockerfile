
# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER Matthew Harrison

#We are going to expose port 80 so that our application will be accessible from the outside. 
#sudo docker run -i -t -p 80:80 ubuntu /bin/bash

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.utf8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN  echo "deb http://archive.ubuntu.com/ubuntu/ raring main universe" >> /etc/apt/sources.list
RUN apt-get -y -q update
# Install SSH 
RUN apt-get -qq -y install openssh-server

RUN mkdir -p /var/run/sshd && \
    echo $USERNAMEPASSWORD | chpasswd
# Install supervisor
RUN apt-get install -yqq supervisor
RUN apt-get clean


# Setup and install litecoin
RUN sudo apt-get install -y build-essential git libssl-dev libdb5.1++-dev libboost-all-dev libqrencode-dev

RUN sudo apt-get install python-software-properties
RUN sudo add-apt-repository ppa:bitcoin/bitcoin
RUN sudo apt-get update
RUN sudo apt-get install bitcoind


# Config ssh and supervisor
# Setup ssh keys
RUN echo "IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/authorized_keys

# supervisor
RUN mkdir -p /etc/supervisor
RUN cp /Bitcoind-Docker/supervisord.conf /etc/supervisor/supervisord.conf
RUN touch /var/log/bitcoind_supervisor.log

#Setup bitcoin
RUN mkdir ~/.bitcoin/
RUN cp /Bitcoind-Docker/bitcoin.conf ~/.bitcoin/bitcoin.conf

#Supervisor
EXPOSE 11300
#SSH
EXPOSE 22
# litecoin
EXPOSE 8333

CMD supervisord
