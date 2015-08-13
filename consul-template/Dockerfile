FROM ubuntu:14.04

MAINTAINER Wagner Souza <wagnersza@gmail.com>

ADD https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_0.10.0_linux_amd64.tar.gz /tmp/
RUN tar -zxf /tmp/consul-template_0.10.0_linux_amd64.tar.gz -C /bin/ --strip-components=1 && rm -rf /tmp/consul-template_0.10.0_linux_amd64.tar.gz

ADD https://get.docker.com/builds/Linux/x86_64/docker-latest /bin/docker
RUN chmod +x /bin/docker

ADD ./consul-template.conf /etc/consul-template.conf
VOLUME /data/tsuru
VOLUME /data/router

ENV DOCKER_HOST unix:///tmp/docker.sock

ADD ./run.sh /bin/run.sh
RUN chmod +x /bin/run.sh

ENTRYPOINT run.sh
