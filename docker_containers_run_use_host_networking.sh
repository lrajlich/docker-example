#!/bin/bash

# net=host opens ports on the host VMs interface (which is VirtualBox or Vagrant)
docker run --name mysql -d --net=host dockerexample/mysql
docker run --name redis -d --net=host dockerexample/redis

# Use environment variables to inform sinatra of the address of the backend services (redis, mysql)
HOST_IP=$(boot2docker ip 2>/dev/null)
docker run --name sinatra -d --net=host -e "MYSQL_HOST=${HOST_IP}" -e "REDIS_HOST=${HOST_IP}" dockerexample/sinatra

echo To access the running application, load http://${host_only_ip}:8080/ in your browser
echo To stop containers, run \"docker_containers_stop.sh\"
