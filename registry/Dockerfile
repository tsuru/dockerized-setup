FROM tsuru/base
MAINTAINER Wagner Souza <wagnersza@gmail.com>

RUN apt-get update \
# Install pip
    && apt-get install -y \
        unzip \
        swig \
        python-pip \
# Install deps for backports.lzma (python2 requires it)
        python-dev \
        python-mysqldb \
        python-rsa \
        libssl-dev \
        liblzma-dev \
        libevent1-dev \
    && rm -rf /var/lib/apt/lists/*

ADD ./config /config/
ADD https://github.com/docker/docker-registry/archive/master.zip registry.zip
RUN unzip registry.zip
RUN cp /docker-registry-master/config/boto.cfg /etc/boto.cfg

# Install core
RUN pip install /docker-registry-master/depends/docker-registry-core

# Install registry
RUN pip install file:///docker-registry-master#egg=docker-registry[bugsnag,newrelic,cors]

RUN patch \
 $(python -c 'import boto; import os; print os.path.dirname(boto.__file__)')/connection.py \
 < /docker-registry-master/contrib/boto_header_patch.diff

ENV DOCKER_REGISTRY_CONFIG /docker-registry-master/config/config_sample.yml
ENV SETTINGS_FLAVOR dev

EXPOSE 5000

ADD ./circus.ini /tmp/circus.ini

ENTRYPOINT /tmp/circus/bin/circusd /tmp/circus.ini --log-output /var/log/circus.log
