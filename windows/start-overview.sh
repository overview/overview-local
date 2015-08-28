#!/bin/bash


## Start services
docker start overview-database
docker start overview-messagebroker
docker start overview-redis
docker start overview-searchindex


## Wait a few seconds to make sure database comes up
## then apply evolutions
sleep 5
docker run --name db-evolution-applier \
  --link overview-database \
  --rm \
  overview/db-evolution-applier


## Add entries for plugins
docker run --name plugin-setup \
  --link overview-database \
  --rm \
  --env DOCKER_HOST=$DOCKER_HOST \
  overview/plugin-setup

## Start plugins
docker start overview-word-cloud
docker start overview-entity-filter
docker start overview-grep
docker start overview-file-browser
docker start overview-multi-search


## Start Overview
docker start documentset-worker
docker start worker
docker start web


