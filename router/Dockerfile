FROM ubuntu:14.04

MAINTAINER Wagner Souza <wagnersza@gmail.com>
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B0DE9C5DEBF486359EB255B03B0153D0383F073D
RUN echo "deb http://ppa.launchpad.net/tsuru/ppa/ubuntu trusty main"  > /etc/apt/sources.list.d/tsuru.list
RUN apt-get update
RUN apt-get install -y node-hipache redis-server unzip patch

ADD https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_0.10.0_linux_amd64.tar.gz /tmp/
RUN tar -zxf /tmp/consul-template_0.10.0_linux_amd64.tar.gz -C /bin/ --strip-components=1 && rm -rf /tmp/consul-template_0.10.0_linux_amd64.tar.gz

EXPOSE      8080

ADD ./hipache.conf /etc/hipache.conf
ADD ./redis.ctmpl /tmp/redis.ctmpl
ADD ./run.sh /bin/run.sh
RUN chmod +x /bin/run.sh

ENTRYPOINT /bin/run.sh
