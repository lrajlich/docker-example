FROM ubuntu

## Environment
ENV DEBIAN_FRONTEND noninteractive
RUN cat /usr/sbin/policy-rc.d | sed -e "s/101/0/" > /usr/sbin/policy-rc.d

## Install Redis
RUN apt-get update
RUN apt-get install -y --force-yes  redis-server

## Configure redis
ADD redis.conf /etc/redis/redis.conf
EXPOSE 6379

## Startup command
CMD ["/usr/bin/redis-server"]
