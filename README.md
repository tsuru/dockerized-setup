## under construction


# dockerized setup for tsuru deployment


# Constraints

   * needs to be OS agnostic
   * host needs to depend only on docker
   * ...


## Consul approach

This project is a Docker container for [tsuru](https://tsuru.io) with [Consul](http://www.consul.io/). It's a slightly opinionated, pre-configured tsuru with Consul Agent made specifically to work in the Docker ecosystem.

## Just trying out tsuru

If you just want to run a single instance of tsuru to try out its functionality:

Configuring and install docker (now for ubuntu only)

```bash
$ curl -sSL https://get.docker.com/ubuntu/ |sh +
$ echo "DOCKER_OPTS=‘-H tcp://0.0.0.0:2375 --insecure-registry 192.168.0.0/16 --dns 172.17.42.1 --dns 8.8.8.8 --dns-search service.tsuru'" >> /etc/default/docker
$ restart docker
```

```bash
$ docker run -d --name api -h api -e CONSUL_ARGS="-server -bootstrap" -e HOST_IP="10.25.43.22" -p 8400:8400 -p 8500:8500 -p 8080:8080 -p 53:53/udp tsuru/api
```

We publish 8400 (RPC), 8500 (HTTP), and 53 (DNS) so you can try all three interfaces. We also give it a hostname of api. Setting the container hostname is the intended way to name the Consul

We can get the container's internal IP by inspecting the container. We'll put it in the env var JOIN_IP

```bash
$ JOIN_IP="$(docker inspect -f '{{.NetworkSettings.IPAddress}}' api)"
```

Then we'll start redis node and tell it to join api using $JOIN_IP:

```bash
$ docker run -d --name redis -h redis -e CONSUL_ARGS="-join $JOIN_IP" tsuru/redis
```

Now we can start mongodb the same way:

```bash
$ docker run -d --name mongodb -h mongodb -e CONSUL_ARGS="-join $JOIN_IP" tsuru/mongodb
```

We can start router

```bash
$ docker run -d --name router -h router -p 80:8080 -e CONSUL_ARGS="-join $JOIN_IP" tsuru/router
```

We can start gandalf

```bash
$ docker run -d --name gandalf -h gandalf -e CONSUL_ARGS="-join $JOIN_IP" tsuru/gandalf
```

We can start registry

```bash
docker run -d --name registry -h registry -p 5000:5000 -e CONSUL_ARGS="-join $JOIN_IP" tsuru/registry
```

We now have a real tsuru running on a single host. Notice we've also named the containers after their internal hostnames / node names.


## Running a real tsuru cluster in a production environment

Configuring and install docker (now for ubuntu only)

```bash
$ curl -sSL https://get.docker.com/ubuntu/ |sh +
$ echo "DOCKER_OPTS=‘-H tcp://0.0.0.0:2375 --insecure-registry 192.168.0.0/16 --dns  192.168.33.11 --dns 192.168.33.12 --dns 192.168.33.13 --dns 8.8.8.8 --dns-search service.tsuru'" >> /etc/default/docker
$ restart docker
```

Setting up a real cluster on separate hosts is very similar to our single host cluster setup process, but with a few differences:

 * We assume there is a private network between hosts. Each host should have an IP on this private network
 * We're going to pass this private IP to tsuru via the `-advertise` flag
 * We're going to publish all ports, including internal Consul ports (8300, 8301, 8302), on this IP
 * We set up a volume at `/data` for persistence. As an example, we'll bind mount `/data` from the host

### Running tsuru API

Assuming we're on a host with a private IP of 192.168.33.11 and the IP of docker bridge docker0 is 172.17.42.1 we can start the first host agent:

    $ docker run -d -h tsuru-api-node1 -v /data/api:/data/api \
        -p 8300:8300 \
        -p 8301:8301 \
        -p 8301:8301/udp \
        -p 8302:8302 \
        -p 8302:8302/udp \
        -p 8400:8400 \
        -p 8500:8500 \
        -p 8080:8080 \
        -p 172.17.42.1:53:53/udp \
        -e CONSUL_ARGS="-server -bootstrap-expect 3" tsuru/api

On the second host, we'd run the same thing, but passing a `-join` to the first node's IP. Let's say the private IP for this host is 192.168.33.12:

    $ docker run -d -h tsuru-api-node2 -v /data/api:/data/api \
        -p 8300:8300 \
        -p 8301:8301 \
        -p 8301:8301/udp \
        -p 8302:8302 \
        -p 8302:8302/udp \
        -p 8400:8400 \
        -p 8500:8500 \
        -p 8080:8080 \
        -p 172.17.42.1:53:53/udp \
        -e CONSUL_ARGS="-server -advertise 192.168.33.12 -join 192.168.33.11" tsuru/api

And the third host with an IP of 192.168.33.13:

    $ docker run -d -h tsuru-api-node3 -v /data/api:/data/api \
        -p 8300:8300 \
        -p 8301:8301 \
        -p 8301:8301/udp \
        -p 8302:8302 \
        -p 8302:8302/udp \
        -p 8400:8400 \
        -p 8500:8500 \
        -p 8080:8080 \
        -p 172.17.42.1:53:53/udp \
        -e CONSUL_ARGS="-server -advertise 192.168.33.13 -join 192.168.33.11" tsuru/api

### Running gandalf

Gandalf first host

    $ docker run -d -h tsuru-gandalf-node1 -v /data/gandalf:/data/gandalf \
        -p 8300:8300 \
        -p 8301:8301 \
        -p 8301:8301/udp \
        -p 8302:8302 \
        -p 8302:8302/udp \
        -p 8400:8400 \
        -p 8500:8500 \
        -p 8081:8081 \
        -p 172.17.42.1:53:53/udp \
        -e CONSUL_ARGS="-advertise 192.168.33.14 -join consul.service.tsuru" tsuru/gandalf

On the second host

    $ docker run -d -h tsuru-gandalf-node2 -v /data/gandalf:/data/gandalf \
        -p 8300:8300 \
        -p 8301:8301 \
        -p 8301:8301/udp \
        -p 8302:8302 \
        -p 8302:8302/udp \
        -p 8400:8400 \
        -p 8500:8500 \
        -p 8081:8081 \
        -p 172.17.42.1:53:53/udp \
        -e CONSUL_ARGS="-advertise 192.168.33.15 -join consul.service.tsuru" tsuru/gandalf

## Links

https://www.consul.io/docs/index.html  
https://github.com/hashicorp/consul-template  
https://github.com/progrium/docker-consul  
