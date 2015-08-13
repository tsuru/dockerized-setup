/etc/init.d/tsuru-server-api start
/bin/consul-template -consul consul.service.consul:8500 -template "/tmp/tsuru.ctmpl:/etc/tsuru/tsuru.conf:/etc/init.d/tsuru-server-api restart"
