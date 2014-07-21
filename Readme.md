## Summary
This project is a comprehensive docker example. It creates 3 different docker images (mysql, redis, sinatra) and then the docker images can be run as containers in 3 different ways, showing the different networking options for Docker. 

## Pre-Requisites
1) <a href="https://docs.docker.com/installation/mac/">Install Docker</a>. The linked page takes you through the setup steps. This will install a boot2docker program. All subsequent operations are to be run from inside.
2) Clone this repository.

## Build Docker Images
In the project root directory is a Makefile, which has targets to invoke the appropriate docker build commands. The Makefile targets are "all", "sinatra", "redis", and "mysql", "sinatra\_clean", "redis\_clean", "mysql\_clean". 

To build all the docker images in one shot, run:

```bash
make all
```

After the docker images are built, using ```docker images``` command you should be able to see three docker images "dockerexample/sinatra", "dockerexample/mysql", and "dockerexample/redis". ex:

```bash
bash-3.2$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
dockerexample/sinatra   latest              bd2202afbe7f        20 hours ago        442.6 MB
dockerexample/mysql     latest              158e97a4caa9        3 days ago          421.7 MB
dockerexample/redis     latest              7d8d07f39c49        3 days ago          264.2 MB
ubuntu                  14.04               e54ca5efa2e9        4 weeks ago         276.5 MB
```

## Run Docker containers

There are 3 different ways to run the docker containers, to highlight the different ways which networking is done at the container level in docker.

#### Run with Linking

To run the containers with linking (<a href="https://docs.docker.com/userguide/dockerlinks/">Linkig documentation</a>), run:

```bash
./docker_containers_run_use_link.sh
```

#### Run with host networking

To run the containers with Host networking, specifying ```--net=host``` for each container, run:
```bash
./docker_containers_run_use_host_networking.sh
```

Once the containers are running, ```docker ps -a``` will show 3 running containers. Notice that there is nothing list for "ports" as the ports are now open directly on the host interface. Also, note that name doesn't show any linking between containers.
```bash
bash-3.2$ docker ps -a
CONTAINER ID        IMAGE                          COMMAND                CREATED             STATUS              PORTS               NAMES
e4cc23ff12d6        dockerexample/sinatra:latest   /usr/local/bin/forem   6 seconds ago       Up 2 seconds                            sinatra             
a3a09e0bd1e4        dockerexample/redis:latest     /usr/bin/redis-serve   6 seconds ago       Up 3 seconds                            redis               
271576fdf5f9        dockerexample/mysql:latest     /usr/bin/mysqld_safe   6 seconds ago       Up 3 seconds                            mysql   
```

#### Run with port forwarding
The final way in which the containers can be run is to create a portforwarding rule on the host VM and use localhost interface to access the application. To run the containers in this way, run:
```bash
./docker_containers_run_use_port_forwarding.sh
```
