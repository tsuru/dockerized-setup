FROM tsuru/base
MAINTAINER Wagner Souza <wagnersza@gmail.com>
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B0DE9C5DEBF486359EB255B03B0153D0383F073D
RUN echo deb http://ppa.launchpad.net/tsuru/ppa/ubuntu trusty main  > /etc/apt/sources.list.d/tsuru.list
RUN apt-get update && apt-get install -y node-hipache
EXPOSE      8080

VOLUME	/data/router

ADD ./config /config/
ADD ./hipache.ctmpl /tmp/hipache.ctmpl
ADD ./hipache /etc/init.d/hipache
RUN chmod +x /etc/init.d/hipache
ADD ./circus.ini /tmp/circus.ini

ENTRYPOINT /tmp/circus/bin/circusd /tmp/circus.ini
