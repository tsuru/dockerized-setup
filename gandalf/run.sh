#!/bin/bash

TSURU_TOKEN=`curl -s http://consul.service.consul:8500/v1/kv/tsuru/token?raw`

chown -R git:git /data/gandalf

if [ "$TSURU_TOKEN" == "" ]; then
  TSURU_TOKEN=`/bin/docker run -v /data/tsuru:/data/tsuru tsuru/tsuru-api token --config=/data/tsuru/tsuru.conf`
  curl -s -X PUT -d $TSURU_TOKEN http://consul.service.consul:8500/v1/kv/tsuru/token
  /bin/docker run -v /data/tsuru:/data/tsuru tsuru/tsuru-api gandalf-sync --config=/data/tsuru/tsuru.conf
  /usr/sbin/sshd -D &
  /usr/sbin/rsyslogd &
  /usr/bin/gandalf-server -config=/data/gandalf/gandalf.conf
else
  /bin/docker run -v /data/tsuru:/data/tsuru tsuru/tsuru-api gandalf-sync --config=/data/tsuru/tsuru.conf
  /usr/sbin/sshd -D &
  /usr/sbin/rsyslogd &
  /usr/bin/gandalf-server -config=/data/gandalf/gandalf.conf
fi
