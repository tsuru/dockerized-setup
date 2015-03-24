# dockerized setup for tsuru deployment

## under construction


This project is a Docker container for [tsuru](https://tsuru.io) with [Consul](http://www.consul.io/). It's a slightly opinionated, pre-configured tsuru with Consul Agent made specifically to work in the Docker ecosystem.

## Just trying out tsuru

If you just want to run a single instance of tsuru to try out its functionality:

```bash
$ docker run -d --name api -h api -e CONSUL_ARGS="-server -bootstrap-expect 3" -e HOST_IP="10.25.43.22" -p 8400:8400 -p 8500:8500 -p 8080:8080 -p 53:53/udp tsuru/api
```

```bash
$ JOIN_IP="$(docker inspect -f '{{.NetworkSettings.IPAddress}}' api)"
```

```bash
$ docker run -d --name redis -h redis -e CONSUL_ARGS="-server -join $JOIN_IP" tsuru/redis
```

```bash
$ docker run -d --name mongodb -h mongodb -e CONSUL_ARGS="-server -join $JOIN_IP" tsuru/mongodb
```

```bash
$ docker run -d --name router -h router -p 80:8080 -e CONSUL_ARGS="-join $JOIN_IP" tsuru/router
```

```bash
$ docker run -d --name gandalf -h gandalf -e CONSUL_ARGS="-join $JOIN_IP" tsuru/gandalf
```

```bash
docker run -d --name registry -h registry -p 5000:5000 -e CONSUL_ARGS="-join $JOIN_IP" tsuru/registry
```

## Running a real tsuru cluster in a production environment

Setting up a real cluster on separate hosts is very similar to our single host cluster setup process, but with a few differences:

 * We assume there is a private network between hosts. Each host should have an IP on this private network
 * We're going to pass this private IP to tsuru via the `-advertise` flag
 * We're going to publish all ports, including internal Consul ports (8300, 8301, 8302), on this IP
 * We set up a volume at `/data` for persistence. As an example, we'll bind mount `/data` from the host

### Running tsuru API

Assuming we're on a host with a private IP of 192.168.33.11 and the IP of docker bridge docker0 is 172.17.42.1 we can start the first host agent:

    $ docker run -d -h tsuru-api-node1 -v /data/api:/data/api \
        -p 192.168.33.11:8300:8300 \
        -p 192.168.33.11:8301:8301 \
        -p 192.168.33.11:8301:8301/udp \
        -p 192.168.33.11:8302:8302 \
        -p 192.168.33.11:8302:8302/udp \
        -p 192.168.33.11:8400:8400 \
        -p 192.168.33.11:8500:8500 \
        -p 192.168.33.11:8080:8080 \
        -p 172.17.42.1:53:53/udp \
        -e CONSUL_ARGS="-server -bootstrap-expect 3" tsuru/api

On the second host, we'd run the same thing, but passing a `-join` to the first node's IP. Let's say the private IP for this host is 192.168.33.12:

    $ docker run -d -h tsuru-api-node2 -v /data/api:/data/api \
        -p 192.168.33.12:8300:8300 \
        -p 192.168.33.12:8301:8301 \
        -p 192.168.33.12:8301:8301/udp \
        -p 192.168.33.12:8302:8302 \
        -p 192.168.33.12:8302:8302/udp \
        -p 192.168.33.12:8400:8400 \
        -p 192.168.33.12:8500:8500 \
        -p 192.168.33.12:8080:8080 \
        -p 172.17.42.1:53:53/udp \
        -e CONSUL_ARGS="-server -advertise 192.168.33.12 -join 192.168.33.11" tsuru/api

And the third host with an IP of 192.168.33.13:

    $ docker run -d -h tsuru-api-node3 -v /data/api:/data/api \
        -p 192.168.33.13:8300:8300 \
        -p 192.168.33.13:8301:8301 \
        -p 192.168.33.13:8301:8301/udp \
        -p 192.168.33.13:8302:8302 \
        -p 192.168.33.13:8302:8302/udp \
        -p 192.168.33.13:8400:8400 \
        -p 192.168.33.13:8500:8500 \
        -p 192.168.33.13:8080:8080 \
        -p 172.17.42.1:53:53/udp \
        -e CONSUL_ARGS="-server -advertise 192.168.33.13 -join 192.168.33.11" tsuru/api

### Running gandalf

Gandalf first host

    $ docker run -d -h tsuru-gandalf-node1 -v /data/gandalf:/data/gandalf \
        -p 192.168.33.14:8300:8300 \
        -p 192.168.33.14:8301:8301 \
        -p 192.168.33.14:8301:8301/udp \
        -p 192.168.33.14:8302:8302 \
        -p 192.168.33.14:8302:8302/udp \
        -p 192.168.33.14:8400:8400 \
        -p 192.168.33.14:8500:8500 \
        -p 192.168.33.14:8081:8081 \
        -p 172.17.42.1:53:53/udp \
        -e CONSUL_ARGS="-advertise 192.168.33.14" tsuru/gandalf

On the second host

    $ docker run -d -h tsuru-gandalf-node2 -v /data/gandalf:/data/gandalf \
        -p 192.168.33.15:8300:8300 \
        -p 192.168.33.15:8301:8301 \
        -p 192.168.33.15:8301:8301/udp \
        -p 192.168.33.15:8302:8302 \
        -p 192.168.33.15:8302:8302/udp \
        -p 192.168.33.15:8400:8400 \
        -p 192.168.33.15:8500:8500 \
        -p 192.168.33.15:8081:8081 \
        -p 172.17.42.1:53:53/udp \
        -e CONSUL_ARGS="-advertise 192.168.33.15" tsuru/gandalf

## Links

https://www.consul.io/docs/index.html  
https://github.com/hashicorp/consul-template  
https://github.com/progrium/docker-consul  