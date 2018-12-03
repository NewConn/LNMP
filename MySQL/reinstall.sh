#!/usr/bin/bash
rm /log/mysql/error.log
rm -rf /data/mysql/data/
touch /log/mysql/error.log
chown -R mysql:mysql /log/mysql
