# Multi host, all in one HA Deployment

![alt tag](https://docs.google.com/drawings/d/1keaBom6LYUfcWLurUEIsWmoc3Nze7lIokMoAiamHxwI/pub?w=3681&amp;h=1488)

## Install hosts
  ```bash
  $ docker-machine create \
    --engine-opt dns=172.17.42.1 \
    --engine-opt dns=8.8.8.8 \
    --engine-opt dns-search=service.consul \
    -d virtualbox docker01

  $ docker-machine create \
    --engine-opt dns=172.17.42.1 \
    --engine-opt dns=8.8.8.8 \
    --engine-opt dns-search=service.consul \
    -d virtualbox docker02

  $ docker-machine create \
    --engine-opt dns=172.17.42.1 \
    --engine-opt dns=8.8.8.8 \
    --engine-opt dns-search=service.consul \
    -d virtualbox docker03
  ```

## Start host image dependences

### Consul

  ```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d -v /data/consul:/data/consul \
    --name consul \
    -e SERVICE_NAME="consul" \
    --restart=always \
    -p 8300:8300 \
    -p 8301:8301 \
    -p 8301:8301/udp \
    -p 8302:8302 \
    -p 8302:8302/udp \
    -p 8400:8400 \
    -p 8500:8500 \
    -p 53:53/udp \
    progrium/consul -server -advertise `docker-machine ip docker01` -bootstrap-expect 3

  $ eval "$(docker-machine env docker02)"
  $ docker run -d -v /data/consul:/data/consul \
    --name consul \
    -e SERVICE_NAME="consul" \
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

  $ eval "$(docker-machine env docker03)"
  $ docker run -d -v /data/consul:/data/consul \
    --name consul \
    -e SERVICE_NAME="consul" \
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
  ```
### Consul registrator

  ```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d -v /var/run/docker.sock:/tmp/docker.sock \
    --name registrator \
    -e SERVICE_NAME="registrator" \
    --restart=always \
    gliderlabs/registrator -ip `docker-machine ip docker01` -resync 5 consul://`docker-machine ip docker01`:8500

  $ eval "$(docker-machine env docker02)"
  $ docker run -d -v /var/run/docker.sock:/tmp/docker.sock \
    --name registrator \
    -e SERVICE_NAME="registrator" \
    --restart=always \
    gliderlabs/registrator -ip `docker-machine ip docker02` -resync 5 consul://`docker-machine ip docker02`:8500

  $ eval "$(docker-machine env docker03)"
  $ docker run -d -v /var/run/docker.sock:/tmp/docker.sock \
    --name registrator \
    -e SERVICE_NAME="registrator" \
    --restart=always \
    gliderlabs/registrator -ip `docker-machine ip docker03` -resync 5 consul://`docker-machine ip docker03`:8500
  ```

### Consul template
  ```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d \
    --name consul-template \
    -e SERVICE_NAME="consul-template" \
    --restart=always \
    -v /var/run/docker.sock:/tmp/docker.sock \
    -v /data/tsuru:/data/tsuru \
    -v /data/router:/data/router \
    -v /data/gandalf:/data/gandalf \
    -v /data/archive-server:/data/archive-server \
    tsuru/consul-template

  $ eval "$(docker-machine env docker02)"
  $ docker run -d \
    --name consul-template \
    -e SERVICE_NAME="consul-template" \
    --restart=always \
    -v /var/run/docker.sock:/tmp/docker.sock \
    -v /data/tsuru:/data/tsuru \
    -v /data/router:/data/router \
    -v /data/gandalf:/data/gandalf \
    -v /data/archive-server:/data/archive-server \
    tsuru/consul-template

  $ eval "$(docker-machine env docker03)"
  $ docker run -d \
    --name consul-template \
    -e SERVICE_NAME="consul-template" \
    --restart=always \
    -v /var/run/docker.sock:/tmp/docker.sock \
    -v /data/tsuru:/data/tsuru \
    -v /data/router:/data/router \
    -v /data/gandalf:/data/gandalf \
    -v /data/archive-server:/data/archive-server \
    tsuru/consul-template
  ```
## Start tsuru

### MongoDB
  ```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d \
    --name mongo \
    -e SERVICE_NAME="mongo" \
    --restart=always \
    -p 27017:27017 \
    mongo --replSet rStsuru

  $ eval "$(docker-machine env docker02)"
  $ $ docker run -d \
    --name mongo \
    -e SERVICE_NAME="mongo" \
    --restart=always \
    -p 27017:27017 \
    mongo --replSet rStsuru

  $ eval "$(docker-machine env docker03)"
  $ $ docker run -d \
    --name mongo \
    -e SERVICE_NAME="mongo" \
    --restart=always \
    -p 27017:27017 \
    mongo --replSet rStsuru
  $ docker exec mongo mongo --eval "JSON.stringify(rs.initiate());"
  $ docker exec mongo mongo --eval "JSON.stringify(rs.add('`docker-machine ip docker01`:27017'))"
  $ docker exec mongo mongo --eval "JSON.stringify(rs.add('`docker-machine ip docker02`:27017'))"
  ```
### Redis (TODO - support redis cluster to implement HA)
  ```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d \
    --name redis \
    -e SERVICE_NAME="redis" \
    --restart=always \
    -p 6379:6379 \
    redis
  ```
### Docker Registry
  ```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d \
    --name registry \
    -e SERVICE_NAME="registry" \
    --restart=always \
    -p 5000:5000 \
    registry

  $ eval "$(docker-machine env docker02)"
  $ docker run -d \
    --name registry \
    -e SERVICE_NAME="registry" \
    --restart=always \
    -p 5000:5000 \
    registry

  $ eval "$(docker-machine env docker03)"
  $ docker run -d \
    --name registry \
    -e SERVICE_NAME="registry" \
    --restart=always \
    -p 5000:5000 \
    registry

  ```
### Router
  ```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d \
    --name router-hipache \
    -e SERVICE_NAME="router-hipache" \
    --restart=always \
    -p 8080:8080 \
    tsuru/router-hipache

  $ eval "$(docker-machine env docker02)"
  $ docker run -d \
    --name router-hipache \
    -e SERVICE_NAME="router-hipache" \
    --restart=always \
    -p 8080:8080 \
    tsuru/router-hipache

  $ eval "$(docker-machine env docker03)"
  $ docker run -d \
    --name router-hipache \
    -e SERVICE_NAME="router-hipache" \
    --restart=always \
    -p 8080:8080 \
    tsuru/router-hipache
  ```
### Tsuru API
  ```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d \
    --name tsuru-api \
    -e SERVICE_NAME="tsuru-api" \
    --restart=always \
    -p 8000:8000 \
    -v /data/tsuru:/data/tsuru \
    tsuru/tsuru-api api --config=/data/tsuru/tsuru.conf

  $ eval "$(docker-machine env docker02)"
  $ docker run -d \
    --name tsuru-api \
    -e SERVICE_NAME="tsuru-api" \
    --restart=always \
    -p 8000:8000 \
    -v /data/tsuru:/data/tsuru \
    tsuru/tsuru-api api --config=/data/tsuru/tsuru.conf

  $ eval "$(docker-machine env docker03)"
  $ docker run -d \
    --name tsuru-api \
    -e SERVICE_NAME="tsuru-api" \
    --restart=always \
    -p 8000:8000 \
    -v /data/tsuru:/data/tsuru \
    tsuru/tsuru-api api --config=/data/tsuru/tsuru.conf
  ```
### Archive Server
  ```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d \
    --name archive-server \
    -e SERVICE_NAME="archive-server" \
    --restart=always \
    -p 3031:3031 \
    -p 3032:3032 \
    -v /data/archive-server:/data/archive-server \
    -v /data/gandalf:/data/gandalf \
    tsuru/archive-server

  $ eval "$(docker-machine env docker02)"
  $ docker run -d \
    --name archive-server \
    -e SERVICE_NAME="archive-server" \
    --restart=always \
    -p 3031:3031 \
    -p 3032:3032 \
    -v /data/archive-server:/data/archive-server \
    -v /data/gandalf:/data/gandalf \
    tsuru/archive-server

  $ eval "$(docker-machine env docker03)"
  $ docker run -d \
    --name archive-server \
    -e SERVICE_NAME="archive-server" \
    --restart=always \
    -p 3031:3031 \
    -p 3032:3032 \
    -v /data/archive-server:/data/archive-server \
    -v /data/gandalf:/data/gandalf \
    tsuru/archive-server
  ```
### Gandalf
  ```bash
  $ eval "$(docker-machine env docker01)"
  $ docker run -d \
    --name gandalf \
    -e SERVICE_NAME="gandalf" \
    --restart=always \
    -p 8001:8001 \
    -v /data/gandalf:/data/gandalf \
    -v /data/tsuru:/data/tsuru \
    -v /var/run/docker.sock:/tmp/docker.sock \
    tsuru/gandalf

  $ eval "$(docker-machine env docker02)"
  $ docker run -d \
    --name gandalf \
    -e SERVICE_NAME="gandalf" \
    --restart=always \
    -p 8001:8001 \
    -v /data/gandalf:/data/gandalf \
    -v /data/tsuru:/data/tsuru \
    -v /var/run/docker.sock:/tmp/docker.sock \
    tsuru/gandalf

  $ eval "$(docker-machine env docker03)"
  $ docker run -d \
    --name gandalf \
    -e SERVICE_NAME="gandalf" \
    --restart=always \
    -p 8001:8001 \
    -v /data/gandalf:/data/gandalf \
    -v /data/tsuru:/data/tsuru \
    -v /var/run/docker.sock:/tmp/docker.sock \
    tsuru/gandalf
  ```
