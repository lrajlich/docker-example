FROM ubuntu

## Environment
ENV DEBIAN_FRONTEND noninteractive
RUN cat /usr/sbin/policy-rc.d | sed -e "s/101/0/" > /usr/sbin/policy-rc.d

## Install ruby
RUN apt-get update
RUN apt-get install -y --force-yes ruby ruby-dev

## Install native package dependencies for ruby gems
RUN apt-get install -y --force-yes build-essential git libmysqlclient-dev

## Add app code and install dependencies
RUN gem install bundler
ADD app/ /opt/app
RUN cd /opt/app; bundle install

EXPOSE 8080

## Startup command
CMD ["/usr/local/bin/foreman","start","-d","/opt/app"]