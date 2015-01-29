# dockerized setup for tsuru deployment

## under construction

## howto test

Make docker images and run:

```bash
$ docker run -d --name node1 -h node1 progrium/consul -server -bootstrap-expect 3
```

```bash
$ JOIN_IP="$(docker inspect -f '{{.NetworkSettings.IPAddress}}' node1)"
```

```bash
$ docker run -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp --name node2 -h node2 progrium/consul -join $JOIN_IP
```

```bash
$ docker run -d --name redis -h redis -e JOIN_IP=$JOIN_IP -p 6379:6379 tsuru/redis
```

```bash
$ docker run -d --name mongodb -h mongodb -e JOIN_IP=$JOIN_IP -p 27017:27017 tsuru/mongodb
```

```bash
$ docker run -d --name router -h router -e JOIN_IP=$JOIN_IP -p 80:8080 tsuru/router
```

```bash
$ docker run -d --name gandalf -h gandalf -e JOIN_IP=$JOIN_IP -p 8081:8081 tsuru/gandalf
```

## Links

https://www.consul.io/docs/index.html  
https://github.com/hashicorp/consul-template  
https://github.com/progrium/docker-consul  