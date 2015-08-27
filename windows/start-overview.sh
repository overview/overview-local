#!/bin/bash


docker start \
  overview-database \
  overview-messagebroker \
  overview-redis \
  overview-searchindex

sleep 5
docker run --name db-evolution-applier \
  --link overview-database \
  --rm overview/db-evolution-applier


docker start \
  documentset-worker \
  worker \
  web
