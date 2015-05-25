FROM ubuntu:trusty
MAINTAINER ClassCat Co.,Ltd. <support@classcat.com>

########################################################################
# ClassCat/Dovecot Dockerfile
#   Maintained by ClassCat Co.,Ltd ( http://www.classcat.com/ )
########################################################################

#--- HISTORY -----------------------------------------------------------
# 25-may-15 : quay.io
#-----------------------------------------------------------------------

RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y language-pack-en language-pack-en-base \
  && apt-get install -y language-pack-ja language-pack-ja-base

RUN update-locale LANG="en_US.UTF-8"

RUN apt-get install -y openssh-server supervisor rsyslog mysql-client && apt-get clean

RUN mkdir -p /var/run/sshd

RUN sed -ri "s/^PermitRootLogin\s+.*/PermitRootLogin yes/" /etc/ssh/sshd_config
# RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

ADD assets/supervisord.conf /etc/supervisor/supervisord.conf

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y dovecot-core dovecot-pop3d dovecot-imapd

WORKDIR /opt
ADD assets/cc-init.sh /opt/cc-init.sh

ADD assets/dovecot /etc/init.d/dovecot

EXPOSE 22 110 143

CMD /opt/cc-init.sh && /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
