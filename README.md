# dockerized setup for tsuru deployment

## under construction

## howto test

Make docker images and run:

docker run -d --name node1 -h node1 progrium/consul -server -bootstrap-expect 3

JOIN_IP="$(docker inspect -f '{{.NetworkSettings.IPAddress}}' node1)"

docker run -d --name redis -h redis -e JOIN_IP=$JOIN_IP -p 6379:6379 tsuru/redis

docker run -d --name mongodb -h mongodb -e JOIN_IP=$JOIN_IP -p 27017:27017 tsuru/mongodb

docker run -d --name router -h router -e JOIN_IP=$JOIN_IP -p 8080:80 tsuru/router