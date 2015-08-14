# Under construction (now is only a POC)

# Single host deploy

## Install machine
  ```bash
  $ docker-machine create \
    --engine-opt dns=172.17.42.1 \
    --engine-opt dns=8.8.8.8 \
    --engine-opt dns-search=service.consul \
    -d virtualbox docker01
  ```

## Start host image dependences

### Consul

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
      progrium/consul -server -advertise `docker-machine ip docker01` -bootstrap
  ```
### Consul registrator  

  ```bash
  $ docker run -d -v /var/run/docker.sock:/tmp/docker.sock \
      --restart=always \
      gliderlabs/registrator consul://`docker-machine ip docker01`:8500
  ```

### Consul template
  ```bash
  $ docker run -d \
    -l name="consul-template" \
    -v /var/run/docker.sock:/tmp/docker.sock \
    -v /data/tsuru:/data/tsuru \
    -v /data/router:/data/router \
    tsuru/consul-template
  ```

## Start tsuru

### MongoDB
  ```bash
  $ docker run -d -e SERVICE_ID="mongo" -p 27017:27017 mongo
  ```
### Redis
  ```bash
  $ docker run -d -e SERVICE_ID="redis" -p 6379:6379 redis
  ```
### Docker Registry
  ```bash
  $ docker run -d -e SERVICE_ID="registry" -p 5000:5000 registry
  ```
### Router
  ```bash
  $ docker run -d -e SERVICE_ID="router" -p 80:8080 tsuru/router
  ```
### Tsuru API
  ```bash
  $ docker run -d \
    -l name="tsuru-api" \
    -e SERVICE_ID="tsuru-api" \
    -p 8000:8000 \
    -v /data/tsuru:/data/tsuru \
    tsuru/api
  ```
