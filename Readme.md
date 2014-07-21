## Summary
This project is a comprehensive docker example. It creates 3 different docker images (mysql, redis, sinatra) and then the docker images can be run as containers in 3 different ways, showing the different networking options for Docker. 

## Pre-Requisites
1) <a href="https://docs.docker.com/installation/mac/">Install Docker</a>. The linked page takes you through the setup steps. This will install a boot2docker program. All subsequent operations are to be run from inside.
2) Clone this repository.

## Build Docker Images
In the project root directory is a makefile, which has targets to invoke the appropriate docker build commands. The makefile targets are "all", "sinatra", "redis", and "mysql". 

To build all the docker images in one shot, run:

```bash
make all
```

After the docker images are built, using "docker images" command you should be able to see three docker images "dockerexample/sinatra", "dockerexample/mysql", and "dockerexample/redis". ex:

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
