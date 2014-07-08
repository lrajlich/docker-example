Commands:

# Build redis docker image 
inside of boot2docker or other VM
make redis

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

## This doesn't work, setting net=host and trying to access from the host
```
docker run -d -net=host -name redis lrajlich/redis
```
After this I cannot connect to redis port from host VM

