#!/bin/bash

docker-compose -f config/services.yml up -d
docker-compose -f config/db-setup.yml up
docker-compose -f config/overview.yml up -d


# The next release of docker-compose will allow environment
# variables to be expanded in the yml file...
echo DOCKER_HOST=$DOCKER_HOST > config/host.env

docker-compose -f config/plugins.yml up -d


