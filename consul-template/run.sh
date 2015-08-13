touch /data/tsuru/tsuru.ctmpl
touch /data/router/hipache.ctmpl
touch /data/router/redis.ctmpl

/bin/consul-template -config /etc/consul-template.conf
