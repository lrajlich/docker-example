#!/bin/bash

## Stop and remove all docker containers

docker stop redis
docker rm redis

docker stop mysql
docker rm mysql

docker stop sinatra
docker rm sinatra
