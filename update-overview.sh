#!/bin/bash

docker-compose -f config/services.yml pull
docker-compose -f config/overview.yml pull
docker-compose -f config/plugins.yml pull
docker pull overview/db-evolution-applier
docker pull overview/plugin-setup
