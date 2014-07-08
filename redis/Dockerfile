FROM ubuntu
ENV DEBIAN_FRONTEND noninteractive
RUN cat /usr/sbin/policy-rc.d | sed -e "s/101/0/" > /usr/sbin/policy-rc.d
RUN apt-get update
RUN apt-get install -y --force-yes  redis-server
EXPOSE 6379
CMD ["/usr/bin/redis-server"]