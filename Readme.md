Commands:

# Build redis docker image 
inside of boot2docker or other VM
```
make redis
```

# Run the image 

## This works... Manually linking
```
docker run -d -p 6379:6379 -name redis lrajlich/redis
docker run -t -i -name redis-client --link="redis:redis" lrajlich/redis /bin/bash
```

In Bash, I can access redis via "redis-cli" on the 2nd container (redis-client)
```
t@5462157e6cf5:/# env | grep REDIS_.*_TCP_ADDR
REDIS_PORT_6379_TCP_ADDR=172.17.0.13
root@5462157e6cf5:/# redis-cli -h 172.17.0.13
172.17.0.13:6379> PING
PONG
```

## This works, exposing port on host and access from the host using host public ip
```
bash-3.2$ docker run -d -p 6379:6379 -name redis lrajlich/redis 
Warning: '-name' is deprecated, it will be replaced by '--name' soon. See usage.
0d2cfb2380fa3c2588b887c8668747a423bac09e8271ca35647bae276e66a46a
bash-3.2$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND                CREATED             STATUS                      PORTS                    NAMES
0d2cfb2380fa        dealpath/redis:latest   /usr/bin/redis-serve   38 seconds ago      Up 35 seconds               0.0.0.0:6379->6379/tcp   redis                
bash-3.2$ redis-cli
Could not connect to Redis at 127.0.0.1:6379: Connection refused
not connected> 
bash-3.2$ boot2docker ip

The VM's Host only interface IP address is: 192.168.59.103

bash-3.2$ redis-cli -h 192.168.59.103
192.168.59.103:6379> PING
PONG
192.168.59.103:6379> quit
```

## This doesn't work, setting net=host and trying to access from the host
```
bash-3.2$ docker run -d --net=host -name redis lrajlich/redis
Warning: '-name' is deprecated, it will be replaced by '--name' soon. See usage.
e11b3879207898a32872b4fc11bfc15418e7db64cecaaf8949df91a22a9a7a4f
bash-3.2$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND                CREATED             STATUS                      PORTS               NAMES
e11b38792078        dealpath/redis:latest   /usr/bin/redis-serve   8 seconds ago       Up 5 seconds                                    redis 
bash-3.2$ redis-cli
Could not connect to Redis at 127.0.0.1:6379: Connection refused
not connected> quit
bash-3.2$ boot2docker ip

The VM's Host only interface IP address is: 192.168.59.103

bash-3.2$ redis-cli -h 192.168.59.103
192.168.59.103:6379> PING
PONG
192.168.59.103:6379> quit
```
After this I cannot connect to redis port from host VM



