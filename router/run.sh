/etc/init.d/redis-server start
/etc/init.d/hipache start
/bin/consul-template -consul consul.service.consul:8500 -template "/tmp/redis.ctmpl:/etc/redis/redis.conf:/etc/init.d/redis-server restart"
