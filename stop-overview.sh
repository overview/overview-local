#!/bin/sh

docker-compose -f config/overview.yml stop
docker-compose -f config/plugins.yml stop
docker-compose -f config/services.yml stop
docker-compose -f config/overview.yml rm -f
docker-compose -f config/plugins.yml rm -f
docker-compose -f config/services.yml rm -f
