#!/bin/bash

docker run --name mysql -d -P dockerexample/mysql
docker run --name redis -d -P dockerexample/redis

## Run using link
# More information on linking - https://docs.docker.com/userguide/dockerlinks/
docker run --name sinatra -d -p 8080:8080 --link mysql:mysql --link redis:redis dockerexample/sinatra

## Print messages to the console
echo To access the running application, load http://$(boot2docker ip 2>/dev/null):8080/ in your browser
echo To stop containers, run \"docker_containers_stop.sh\"
