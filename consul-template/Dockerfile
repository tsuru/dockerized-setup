FROM ubuntu:14.04

MAINTAINER Wagner Souza <wagnersza@gmail.com>

ADD https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_0.10.0_linux_amd64.tar.gz /tmp/
RUN tar -zxf /tmp/consul-template_0.10.0_linux_amd64.tar.gz -C /bin/ --strip-components=1 && rm -rf /tmp/consul-template_0.10.0_linux_amd64.tar.gz

ADD https://get.docker.com/builds/Linux/x86_64/docker-latest /bin/docker
RUN chmod +x /bin/docker

ADD ./consul-template.conf /etc/consul-template.conf
ADD ./tsuru.ctmpl /tmp/tsuru.ctmpl
ADD ./redis.ctmpl /tmp/redis.ctmpl
ADD ./hipache.ctmpl /tmp/hipache.ctmpl
ADD ./gandalf.ctmpl /tmp/gandalf.ctmpl
ADD ./post-receive.ctmpl /tmp/post-receive.ctmpl
ADD ./pre-receive.ctmpl /tmp/pre-receive.ctmpl
ADD ./archive-server.ctmpl /tmp/archive-server.ctmpl

VOLUME /data/tsuru
VOLUME /data/router
VOLUME /data/gandalf
VOLUME /data/archive-server

ENV DOCKER_HOST unix:///tmp/docker.sock

LABEL "name"="consul-template"

ENTRYPOINT /bin/consul-template -config /etc/consul-template.conf
