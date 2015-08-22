#!/bin/bash

docker-compose -f config/services.yml up -d
docker-compose -f config/db-setup.yml up
docker-compose -f config/overview.yml up -d
