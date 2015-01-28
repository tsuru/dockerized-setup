# dockerized setup for tsuru deployment

## under construction

## howto test

Make docker images and run:

```bash
$ docker run -d --name node1 -h node1 progrium/consul -server -bootstrap-expect 3
```

```bash
$ docker run -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp --name node4 -h node4 progrium/consul -join $JOIN_IP
```

```bash
$ JOIN_IP="$(docker inspect -f '{{.NetworkSettings.IPAddress}}' node1)"
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