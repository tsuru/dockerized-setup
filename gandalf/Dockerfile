FROM ubuntu:14.04
MAINTAINER Wagner Souza <wagnersza@gmail.com>
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B0DE9C5DEBF486359EB255B03B0153D0383F073D
RUN echo deb http://ppa.launchpad.net/tsuru/ppa/ubuntu trusty main  > /etc/apt/sources.list.d/tsuru.list
RUN apt-get update && apt-get install -y gandalf-server
EXPOSE      8080
ENTRYPOINT  ["/usr/bin/gandalf-server -config=/data/gandalf/gandalf.conf"]