# Under construction (now is only a POC)

## tsuru docker swarm deploy

## Install consul machine bootstrap
  ```bash
  $ docker-machine create --virtualbox-memory "512" --engine-opt dns=172.17.42.1 --engine-opt dns=8.8.8.8 --engine-opt dns-search=service.consul -d virtualbox consul01
  $ eval "$(docker-machine env consul01)"
  $ docker run -d -v /data/consul:/data/consul \
      --restart=always \
      -p 8300:8300 \
      -p 8301:8301 \
      -p 8301:8301/udp \
      -p 8302:8302 \
      -p 8302:8302/udp \
      -p 8400:8400 \
      -p 8500:8500 \
      -p 53:53/udp \
      progrium/consul -server -advertise `docker-machine ip consul01` -bootstrap
  ```

## Insltall swarm machines
  ```bash
  $ docker-machine create --swarm --swarm-master --swarm-discovery consul://`docker-machine ip consul01`:8500/swarm --engine-opt dns=172.17.42.1 --engine-opt dns=8.8.8.8 --engine-opt dns-search=service.consul -d virtualbox docker01
  $ docker-machine create --swarm --swarm-discovery consul://`docker-machine ip consul01`:8500/swarm --engine-opt dns=172.17.42.1 --engine-opt dns=8.8.8.8 --engine-opt dns-search=service.consul -d virtualbox docker02
  $ docker-machine create --swarm --swarm-discovery consul://`docker-machine ip consul01`:8500/swarm --engine-opt dns=172.17.42.1 --engine-opt dns=8.8.8.8 --engine-opt dns-search=service.consul -d virtualbox docker03
  ```
## Install consul cluster and registrator

  ```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d -v /data/consul:/data/consul \
      --restart=always \
      -p 8300:8300 \
      -p 8301:8301 \
      -p 8301:8301/udp \
      -p 8302:8302 \
      -p 8302:8302/udp \
      -p 8400:8400 \
      -p 8500:8500 \
      -p 53:53/udp \
      progrium/consul -server -advertise `docker-machine ip docker01` -join `docker-machine ip consul01`

  $ docker run -d -v /var/run/docker.sock:/tmp/docker.sock \
      --restart=always \
      gliderlabs/registrator consul://`docker-machine ip docker01`:8500
  ```
  ```bash
  $ eval "$(docker-machine env docker02)"
  $ docker run -d -v /data/consul:/data/consul \
      --restart=always \
      -p 8300:8300 \
      -p 8301:8301 \
      -p 8301:8301/udp \
      -p 8302:8302 \
      -p 8302:8302/udp \
      -p 8400:8400 \
      -p 8500:8500 \
      -p 53:53/udp \
      progrium/consul -server -advertise `docker-machine ip docker02` -join `docker-machine ip consul01`

  $ docker run -d -v /var/run/docker.sock:/tmp/docker.sock \
      --restart=always \
      gliderlabs/registrator consul://`docker-machine ip docker02`:8500
  ```
  ```bash
  $ eval "$(docker-machine env docker03)"
  $ docker run -d -v /data/consul:/data/consul \
    --restart=always \
    -p 8300:8300 \
    -p 8301:8301 \
    -p 8301:8301/udp \
    -p 8302:8302 \
    -p 8302:8302/udp \
    -p 8400:8400 \
    -p 8500:8500 \
    -p 53:53/udp \
    progrium/consul -server -advertise `docker-machine ip docker03` -join `docker-machine ip consul01`

  $ docker run -d -v /var/run/docker.sock:/tmp/docker.sock \
      --restart=always \
      gliderlabs/registrator consul://`docker-machine ip docker03`:8500
  ```
## Start tsuru tears
  ```bash
  $ eval $(docker-machine env --swarm docker01)
  ```
### MongoDB (single instance)
  ```bash
  $ docker run -d --name mongo -h mongo -p 27017:27017 mongo
  ```
### Redis (single instance)
  ```bash
  $ docker run -d --name redis -h redis -p 6379:6379 redis
  ```
### Docker Registry (multiple instances)
  ```bash
  $ docker run -d -e SERVICE_ID="registry" --name registry -h registry -p 5000:5000 registry
  ```
### Router (multiple instances)
  ```bash
  $ docker run -d -e SERVICE_ID="router" --name router -h router -p 80:8080 wagnersza/router
  ```
### Tsuru API (multiple instances)
  ```bash
  $ docker run -d -e SERVICE_ID="tsuru-api" --name api -h api -p 8000:8000 wagnersza/tsuru-api
  ```

# tsuru docker deploy
```bash
$ docker-machine create --engine-opt dns=172.17.42.1 --engine-opt dns=8.8.8.8 --engine-opt dns-search=service.consul -d virtualbox docker01
$ docker-machine create --engine-opt dns=172.17.42.1 --engine-opt dns=8.8.8.8 --engine-opt dns-search=service.consul -d virtualbox docker02
$ docker-machine create --engine-opt dns=172.17.42.1 --engine-opt dns=8.8.8.8 --engine-opt dns-search=service.consul -d virtualbox docker03
```
```bash
$ eval "$(docker-machine env docker01)"
$ docker run -d --name consul -v /data/consul:/data/consul \
    --restart=always \
    -p 8300:8300 \
    -p 8301:8301 \
    -p 8301:8301/udp \
    -p 8302:8302 \
    -p 8302:8302/udp \
    -p 8400:8400 \
    -p 8500:8500 \
    -p 53:53/udp \
    progrium/consul -server -advertise `docker-machine ip docker01` -bootstrap

$ docker run -d --name registrator -v /var/run/docker.sock:/tmp/docker.sock \
    --restart=always \
    gliderlabs/registrator consul://`docker-machine ip docker01`:8500

$ docker run -d --name mongo -h mongo -p 27017:27017 mongo
$ docker run -d --name redis -h redis -p 6379:6379 redis
```
```bash
$ eval "$(docker-machine env docker02)"
$ docker run -d --name consul -v /data/consul:/data/consul \
    --restart=always \
    -p 8300:8300 \
    -p 8301:8301 \
    -p 8301:8301/udp \
    -p 8302:8302 \
    -p 8302:8302/udp \
    -p 8400:8400 \
    -p 8500:8500 \
    -p 53:53/udp \
    progrium/consul -server -advertise `docker-machine ip docker02` -join `docker-machine ip docker01`

$ docker run -d --name registrator -v /var/run/docker.sock:/tmp/docker.sock \
    --restart=always \
    gliderlabs/registrator consul://`docker-machine ip docker02`:8500

$ docker run -d -e SERVICE_ID="registry" --name registry -h registry -p 5000:5000 registry
```
```bash
$ eval "$(docker-machine env docker03)"
$ docker run -d --name consul -v /data/consul:/data/consul \
  --restart=always \
  -p 8300:8300 \
  -p 8301:8301 \
  -p 8301:8301/udp \
  -p 8302:8302 \
  -p 8302:8302/udp \
  -p 8400:8400 \
  -p 8500:8500 \
  -p 53:53/udp \
  progrium/consul -server -advertise `docker-machine ip docker03` -join `docker-machine ip docker01`

$ docker run -d --name registrator -v /var/run/docker.sock:/tmp/docker.sock \
    --restart=always \
    gliderlabs/registrator consul://`docker-machine ip docker03`:8500

$ docker run -d -e SERVICE_ID="router" --name router -h router -p 8080:8080 wagnersza/router
$ docker run -d -e HOST_IP=`docker-machine ip docker03` -e SERVICE_ID="tsuru-api" --name tsuru-api -h tsuru-api -p 8000:8000 wagnersza/tsuru-api
```
## Start RUNCHER server only for monitoring hosts

```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d -e SERVICE_ID="rancher-server" --name rancher-server --restart=always -p 8888:8080 rancher/server
```
