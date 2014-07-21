FROM ubuntu

## Environment
ENV DEBIAN_FRONTEND noninteractive
RUN cat /usr/sbin/policy-rc.d | sed -e "s/101/0/" > /usr/sbin/policy-rc.d

## Install mysql
RUN apt-get update
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get install -y --force-yes mysql-server

## Configure mysql
ADD my.cnf /etc/mysql/my.cnf
ADD configure_db.sh /tmp/configure_db.sh
RUN /tmp/configure_db.sh
EXPOSE 3306

## Startup command
CMD ["/usr/bin/mysqld_safe"]
