#!/bin/bash

## Setup port forwarding
./vm_port_forwarding_add.sh

# Net=host will automatically port map any open ports on a docker container to the host
docker run --name mysql -d -p 3306:3306 dockerexample/mysql
docker run --name redis -d -p 6379:6379 dockerexample/redis

# Run the application, no link, pass environment variables telling application mysql and redis are on localhost
docker run --name sinatra -d --net=host -e "MYSQL_HOST=127.0.0.1" -e "REDIS_HOST=127.0.0.1" dockerexample/sinatra

echo To access the running application, load http://localhost:8080/ in your browser
echo To stop containers, run \"docker_containers_stop.sh\"
echo To remove port forwarding, run \"vm_port_forwarding_delete.sh\"
