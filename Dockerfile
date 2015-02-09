FROM phusion/baseimage:0.9.16
MAINTAINER Arkadi Shishlov <arkadi.shishlov@gmail.com>

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y wget unzip git openssl coreutils \
    && apt-get clean \
    && find /var/lib/apt/lists -type f -delete

ADD install.sh /tmp/
RUN /tmp/install.sh && rm /tmp/install.sh

ADD app.ini /opt/gogs/app.ini.custom
ADD gogs.sh /etc/service/gogs/run

RUN rm -f /etc/service/sshd/down

VOLUME /home/git
EXPOSE 22 50443
