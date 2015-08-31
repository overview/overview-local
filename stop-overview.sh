#!/bin/bash

docker-compose -f config/overview.yml stop
docker-compose -f config/plugins.yml stop
docker-compose -f config/services.yml stop
