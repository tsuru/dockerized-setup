FROM tsuru/base:latest
MAINTAINER Wagner Souza <wagnersza@gmail.com>
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B0DE9C5DEBF486359EB255B03B0153D0383F073D
RUN echo deb http://ppa.launchpad.net/tsuru/ppa/ubuntu trusty main  > /etc/apt/sources.list.d/tsuru.list
RUN apt-get update && apt-get install -y gandalf-server

VOLUME	/data/gandalf
ADD ./gandalf.ctmpl /tmp/gandalf.ctmpl

EXPOSE 8080 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp

ENTRYPOINT ["/bin/start"]
