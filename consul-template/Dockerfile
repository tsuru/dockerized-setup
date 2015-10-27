FROM ubuntu:14.04

MAINTAINER tsuru <tsuru@corp.globo.com>
ADD https://github.com/hashicorp/consul-template/releases/download/v0.11.0/consul_template_0.11.0_linux_amd64.zip /tmp/
RUN apt-get install -y unzip
RUN unzip /tmp/consul_template_0.11.0_linux_amd64.zip -d /bin && rm -rf /tmp/consul-template_0.11.0_linux_amd64.tar.gz

ADD https://get.docker.com/builds/Linux/x86_64/docker-latest /bin/docker
RUN chmod +x /bin/docker

ADD ./consul-template.conf /etc/consul-template.conf
ADD ./tsuru.ctmpl /tmp/tsuru.ctmpl
ADD ./redis.ctmpl /tmp/redis.ctmpl
ADD ./hipache.ctmpl /tmp/hipache.ctmpl
ADD ./gandalf.ctmpl /tmp/gandalf.ctmpl
ADD ./pre-receive.ctmpl /tmp/pre-receive.ctmpl
ADD ./archive-server.ctmpl /tmp/archive-server.ctmpl

ENV DOCKER_HOST unix:///tmp/docker.sock

LABEL "name"="consul-template"

ENTRYPOINT /bin/consul-template -config /etc/consul-template.conf
