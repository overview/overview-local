#!/bin/bash

docker-compose -f config/services.yml stop
docker-compose -f config/overview.yml stop

docker-compose -f config/services.yml pull
docker-compose -f config/overview.yml pull

