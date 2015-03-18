FROM tsuru/base:latest
MAINTAINER Wagner Souza <wagnersza@gmail.com>
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B0DE9C5DEBF486359EB255B03B0153D0383F073D
RUN echo deb http://ppa.launchpad.net/tsuru/ppa/ubuntu trusty main  > /etc/apt/sources.list.d/tsuru.list
RUN apt-get update && apt-get install -y gandalf-server

EXPOSE 8000

VOLUME	/data/gandalf

ADD ./config /config/
ADD ./gandalf.ctmpl /tmp/gandalf.ctmpl
ADD ./gandalf /etc/init.d/gandalf
RUN chmod +x /etc/init.d/gandalf
ADD ./circus.ini /tmp/circus.ini

ENTRYPOINT /tmp/circus/bin/circusd /tmp/circus.ini --log-output /var/log/circus.log
