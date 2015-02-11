FROM tsuru/base:latest
MAINTAINER Wagner Souza <wagnersza@gmail.com>
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B0DE9C5DEBF486359EB255B03B0153D0383F073D
RUN echo "deb http://ppa.launchpad.net/tsuru/ppa/ubuntu trusty main"  > /etc/apt/sources.list.d/tsuru.list
RUN apt-get update && apt-get install -y tsuru-server

EXPOSE      8080

VOLUME	/data/api

ADD ./config /config/
ADD ./tsuru.ctmpl /tmp/tsuru.ctmpl
ADD ./tsuru-server-api /etc/init.d/tsuru-server-api
RUN chmod +x /etc/init.d/tsuru-server-api
ADD ./circus.ini /tmp/circus.ini

ENTRYPOINT /tmp/circus/bin/circusd /tmp/circus.ini
