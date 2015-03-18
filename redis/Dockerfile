FROM tsuru/base:latest
MAINTAINER Wagner Souza <wagnersza@gmail.com>

RUN         apt-get update && apt-get install -y redis-server

EXPOSE      6379

ADD ./config /config/
ADD ./redis.ctmpl /tmp/redis.ctmpl
ADD ./redis-server /etc/init.d/redis-server
RUN chmod +x /etc/init.d/redis-server
ADD ./circus.ini /tmp/circus.ini

ENTRYPOINT /tmp/circus/bin/circusd /tmp/circus.ini --log-output /var/log/circus.log