FROM ubuntu:14.04

MAINTAINER Wagner Souza <wagnersza@gmail.com>
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B0DE9C5DEBF486359EB255B03B0153D0383F073D
RUN echo "deb http://ppa.launchpad.net/tsuru/ppa/ubuntu trusty main"  > /etc/apt/sources.list.d/tsuru.list
RUN apt-get update && apt-get install -y gandalf-server archive-server curl patch

ADD ./git-daemon /etc/default/git-daemon
ADD ./run.sh /run.sh
RUN chmod +x /run.sh

ADD https://get.docker.com/builds/Linux/x86_64/docker-latest /bin/docker
RUN chmod +x /bin/docker

ENV DOCKER_HOST unix:///tmp/docker.sock

EXPOSE      8001

VOLUME /data/gandalf

LABEL name="gandalf"

RUN chown -R git:git /data/gandalf

ENTRYPOINT /run.sh
