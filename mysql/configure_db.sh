#!/bin/bash

### Invoked from Dockerfile. ###

## Start Database
/usr/bin/mysqld_safe > /dev/null 2>&1 &

## Wait for database to be ready
RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql --user=root --password=root -e "status" > /dev/null 2>&1
    RET=$?
done

## Create "dockerexample" user and database
mysql --user=root --password=root -e "CREATE USER 'dockerexample'@'%' IDENTIFIED BY 'dockerexample'"
mysql --user=root --password=root -e "CREATE DATABASE dockerexample"
mysql --user=root --password=root -e "GRANT ALL PRIVILEGES ON dockerexample.* to 'dockerexample'@'%'"

## Load database schema, which is a table of pageloads timestamps and source ip address
#./rehydrate

## Shut down database
mysqladmin --user=root --password=root shutdown