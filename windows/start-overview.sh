#!/bin/bash


## Start services
docker start \
  overview-database \
  overview-messagebroker \
  overview-redis \
  overview-searchindex

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
docker start \
  overview-word-cloud \
  overview-entity-filter \
  overview-grep \
  overview-file-browser \
  overview-multi-search

## Start Overview
docker start \
  documentset-worker \
  worker \
  web

## Wait for Overview to start
docker run --name up-checker-web \
  --env DOCKER_HOST=$DOCKER_HOST \
  --rm \
  overview/up-checker

start http://$(docker-machine ip default):9000

