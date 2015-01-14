#!/bin/sh

if [ ! -f /etc/npme/.dockerstrapped ]; then
  cp -R /etc/npme_original/* /etc/npme
  touch /etc/npme/.dockerstrapped
fi

cd /etc/npme

service redis-server start | service nginx start | couchdb | npme restart | tail -f ./logs/*
