## Summary
This project is a comprehensive docker example. It creates 3 different docker images (mysql, redis, sinatra) and then the docker images can be run as containers in 3 different ways, highlighting different networking options for Docker. 

## Pre-Requisites
1) <a href="https://docs.docker.com/installation/mac/">Install Docker</a>. The linked page takes you through the setup steps. This will install a boot2docker program. All subsequent operations are to be run from inside boot2docker.<br>
2) Clone this repository.

## Build Docker Images
Once you have docker installed, you can launch the "boot2docker" program. This launches a VM and gives you a shell with an environment for doing "docker" work. In this bash shell launched by boot2docker, navigate to the project root directory. In the root directory is a Makefile, which has a number targets. The Makefile targets are "all", "sinatra", "redis", and "mysql", "sinatra\_clean", "redis\_clean", "mysql\_clean". Each target invokes a ```docker build``` commands. The \_clean targets run docker build with ```--no-cache=true``` parameter, forcing a full re-build of the image.

The make targets invoke ```docker build``` for a specific Dockerfile. Each service has its own Dockerfile, which procedurally defines a docker image. The relevant Dockerfiles are mysql/Dockerfile, redis/Dockerfile, and sinatra/Dockerfile.

To build all the docker images in one shot, run:

```bash
make all
```

After the docker images are built, using ```docker images``` command you should be able to see the three built docker images.
Example:
```bash
bash-3.2$ docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
dockerexample/sinatra   latest              bd2202afbe7f        20 hours ago        442.6 MB
dockerexample/mysql     latest              158e97a4caa9        3 days ago          421.7 MB
dockerexample/redis     latest              7d8d07f39c49        3 days ago          264.2 MB
ubuntu                  14.04               e54ca5efa2e9        4 weeks ago         276.5 MB
```

Now that the images are built, you are ready to run docker containers.

## Run Docker containers

There are 3 different ways to run the docker containers, to highlight the different ways which networking can be done at the container level in docker. These are overlapping in terms of ports and container names, so you can only run the containers one way at a time.

### Run with Linking

Linking is the method which Docker has provided to do cross-container networking inside of a host. In terms of specifics, When a container is linked, docker will set 4 environment variables () and edit the /etc/hosts file adding an entry for the linked container. Internally, on the host, docker sets up a NAT and assigns private ip addresses on that NAT to each container (eg, 172.x.x.x). In, the /etc/hosts, that private ip address is mapped to the containers "alias". This is the most "docker official" manner in which to run . Linking is covered in detail in the <a href="https://docs.docker.com/userguide/dockerlinks/">Docker User Guide.</a>

To run the containers with linking, run:

```bash
./docker_containers_run_use_link.sh
```

Once the containers are running, ```docker ps -a``` will show 3 running containers. 
Example:
```bash
bash-3.2$ docker ps -a
CONTAINER ID        IMAGE                          COMMAND                CREATED             STATUS              PORTS                     NAMES
4462387c8ee3        dockerexample/sinatra:latest   /usr/local/bin/forem   6 seconds ago       Up 3 seconds        0.0.0.0:8080->8080/tcp    sinatra               
c8921f184c18        dockerexample/redis:latest     /usr/bin/redis-serve   6 seconds ago       Up 3 seconds        0.0.0.0:49154->6379/tcp   redis,sinatra/redis   
152d0e372010        dockerexample/mysql:latest     /usr/bin/mysqld_safe   6 seconds ago       Up 3 seconds        0.0.0.0:49153->3306/tcp   mysql,sinatra/mysql 
```

The sinatra application will connect to the backend services using the private ip address on the host's NAT. Thus when you load the application, you will see that mysql and redis see the Sinatra client as a 172.17.x.x address.

To stop the containers, run ```./docker_containers_stop.sh```

### Run with host networking

Host networking is another option for networking in docker. In this case, the docker container uses the host network interface directly. This somewhat breaks the container abstraction setup by docker; however, this is simpler as the container is no longer using a NAT'ed ip address. The one major downside to this approach (vs linking) is that all the containers have to share the same ports. In the case of a single tenant host, this shouldn't be a problem. To run a container with host networking, you specify ```--net=host``` as a parameter to ```docker run```

To run the containers with Host networking, specifying ```--net=host``` for each container, run:
```bash
./docker_containers_run_use_host_networking.sh
```

Once the containers are running, ```docker ps -a``` will show 3 running containers. Notice that there is nothing list for "ports" as the ports are now open directly on the host interface. Also, note that name doesn't show any linking between containers.
Example:
```bash
bash-3.2$ docker ps -a
CONTAINER ID        IMAGE                          COMMAND                CREATED             STATUS              PORTS               NAMES
e4cc23ff12d6        dockerexample/sinatra:latest   /usr/local/bin/forem   6 seconds ago       Up 2 seconds                            sinatra             
a3a09e0bd1e4        dockerexample/redis:latest     /usr/bin/redis-serve   6 seconds ago       Up 3 seconds                            redis               
271576fdf5f9        dockerexample/mysql:latest     /usr/bin/mysqld_safe   6 seconds ago       Up 3 seconds                            mysql   
```

The sinatra application will connect to the backend services using the IP address for the VM (192.168.x.x) Thus when you load the application, you will see that mysql and redis see the Sinatra client as a 192.168.x.x address.

To stop the containers, run ```./docker_containers_stop.sh```

### Run with port forwarding

The final way in which the containers can be run is to create a port forwarding rule on the host VM and use localhost interface to access the application. <a href="https://github.com/boot2docker/boot2docker/blob/master/doc/WORKAROUNDS.md.">This is an official workaround</a>. This is identical on the Host VM (eg, the VirtualBox VM); however, this allows the convenience of being able to access the application from your computer's browser.

To run the containers in this way, run:
```bash
./docker_containers_run_use_port_forwarding.sh
```

Once the containers are running, ```docker ps -a``` will show 3 running containers.
```bash
CONTAINER ID        IMAGE                          COMMAND                CREATED             STATUS              PORTS                    NAMES
f2b4c5b5c73b        dockerexample/sinatra:latest   /usr/local/bin/forem   7 seconds ago       Up 3 seconds                                 sinatra             
e5763e68ffa1        dockerexample/redis:latest     /usr/bin/redis-serve   7 seconds ago       Up 4 seconds        0.0.0.0:6379->6379/tcp   redis               
07e82961b082        dockerexample/mysql:latest     /usr/bin/mysqld_safe   7 seconds ago       Up 4 seconds        0.0.0.0:3306->3306/tcp   mysql 
```

In this case, the sinatra application will connect to the backend services using 127.0.0.1. However, in the application, the mysql and redis see the client ip address as a NAT ip address (172.17.x.x) instead of 127.0.0.1. I have not yet investigated why this is the case but I'm guessing it has to do with how the port forwarding rule is handled.
