# dockerized setup for tsuru deployment

## under construction


This project is a Docker container for [tsuru](https://tsuru.io) with [Consul](http://www.consul.io/). It's a slightly opinionated, pre-configured tsuru with Consul Agent made specifically to work in the Docker ecosystem.

## Just trying out tsuru

If you just want to run a single instance of tsuru to try out its functionality:

```bash
$ docker run -d --name redis -h redis -e JOIN_IP=$JOIN_IP -p 6379:6379 -p 8400:8400 -p 8500:8500 -p 8600:53/udp -e CONSUL_ARGS="-server -bootstrap-expect 3" tsuru/redis
```

```bash
$ JOIN_IP="$(docker inspect -f '{{.NetworkSettings.IPAddress}}' redis)"
```

```bash
$ docker run -d --name mongodb -h mongodb -e CONSUL_ARGS="-server -join $JOIN_IP" -e JOIN_IP=$JOIN_IP -p 27017:27017 tsuru/mongodb
```

```bash
$ docker run -d --name router -h router -e JOIN_IP=$JOIN_IP -e CONSUL_ARGS="-server -join $JOIN_IP" -p 80:8080 tsuru/router
```

```bash
$ docker run -d --name gandalf -h gandalf -e JOIN_IP=$JOIN_IP -e CONSUL_ARGS="-join $JOIN_IP" -p 8081:8081 tsuru/gandalf
```

```bash
$ docker run -d --name tsuru-api -h tsuru-api -e JOIN_IP=$JOIN_IP -e CONSUL_ARGS="-join $JOIN_IP" -p 8080:8080 tsuru/api
```

## Running a real tsuru cluster in a production environment

Setting up a real cluster on separate hosts is very similar to our single host cluster setup process, but with a few differences:

 * We assume there is a private network between hosts. Each host should have an IP on this private network
 * We're going to pass this private IP to tsuru via the `-advertise` flag
 * We're going to publish all ports, including internal Consul ports (8300, 8301, 8302), on this IP
 * We set up a volume at `/data` for persistence. As an example, we'll bind mount `/data` from the host

### Running tsuru API

Assuming we're on a host with a private IP of 10.0.1.1 and the IP of docker bridge docker0 is 172.17.42.1 we can start the first host agent:

	$ docker run -d -h tsuru-api-node1 -v /data/api:/data/api \
	    -p 10.0.1.1:8300:8300 \
	    -p 10.0.1.1:8301:8301 \
	    -p 10.0.1.1:8301:8301/udp \
	    -p 10.0.1.1:8302:8302 \
	    -p 10.0.1.1:8302:8302/udp \
	    -p 10.0.1.1:8400:8400 \
	    -p 10.0.1.1:8500:8500 \
	    -p 10.0.1.1:8080:8080 \
	    -p 172.17.42.1:53:53/udp \
	    -e CONSUL_ARGS="-server -bootstrap-expect 3" tsuru/api

On the second host, we'd run the same thing, but passing a `-join` to the first node's IP. Let's say the private IP for this host is 10.0.1.2:

	$ docker run -d -h tsuru-api-node2 -v /data/api:/data/api \
	    -p 10.0.1.2:8300:8300 \
	    -p 10.0.1.2:8301:8301 \
	    -p 10.0.1.2:8301:8301/udp \
	    -p 10.0.1.2:8302:8302 \
	    -p 10.0.1.2:8302:8302/udp \
	    -p 10.0.1.2:8400:8400 \
	    -p 10.0.1.2:8500:8500 \
	    -p 10.0.1.2:8080:8080 \
	    -p 172.17.42.1:53:53/udp \
	    -e CONSUL_ARGS="-server -advertise 10.0.1.2 -join 10.0.1.1" tsuru/api

And the third host with an IP of 10.0.1.3:

	$ docker run -d -h tsuru-api-node3 -v /data/api:/data/api \
	    -p 10.0.1.3:8300:8300 \
	    -p 10.0.1.3:8301:8301 \
	    -p 10.0.1.3:8301:8301/udp \
	    -p 10.0.1.3:8302:8302 \
	    -p 10.0.1.3:8302:8302/udp \
	    -p 10.0.1.3:8400:8400 \
	    -p 10.0.1.3:8500:8500 \
	    -p 10.0.1.3:8080:8080 \
	    -p 172.17.42.1:53:53/udp \
	    -e CONSUL_ARGS="-server -advertise 10.0.1.3 -join 10.0.1.1" tsuru/api

### Running gandalf

Gandalf first host

	$ docker run -d -h tsuru-gandalf-node1 -v /data/gandalf:/data/gandalf \
	    -p 10.0.1.4:8300:8300 \
	    -p 10.0.1.4:8301:8301 \
	    -p 10.0.1.4:8301:8301/udp \
	    -p 10.0.1.4:8302:8302 \
	    -p 10.0.1.4:8302:8302/udp \
	    -p 10.0.1.4:8400:8400 \
	    -p 10.0.1.4:8500:8500 \
	    -p 10.0.1.4:8081:8081 \
	    -p 172.17.42.1:53:53/udp \
	    -e CONSUL_ARGS="-advertise 10.0.1.4 -join 10.0.1.1" tsuru/gandalf

On the second host

	$ docker run -d -h tsuru-gandalf-node2 -v /data/gandalf:/data/gandalf \
	    -p 10.0.1.5:8300:8300 \
	    -p 10.0.1.5:8301:8301 \
	    -p 10.0.1.5:8301:8301/udp \
	    -p 10.0.1.5:8302:8302 \
	    -p 10.0.1.5:8302:8302/udp \
	    -p 10.0.1.5:8400:8400 \
	    -p 10.0.1.5:8500:8500 \
	    -p 10.0.1.5:8081:8081 \
	    -p 172.17.42.1:53:53/udp \
	    -e CONSUL_ARGS="-advertise 10.0.1.5 -join 10.0.1.1" tsuru/gandalf

## Links

https://www.consul.io/docs/index.html  
https://github.com/hashicorp/consul-template  
https://github.com/progrium/docker-consul  