#!/bin/sh

docker-compose -f config/persistent.yml up

docker-compose -f config/services.yml up -d

docker run \
  --link overview-database \
  --rm busybox \
  /bin/sh -c 'until $(echo | nc overview-database 5432 2>/dev/null); do sleep 1; done'

docker run --net container:overview-network --rm overview/db-evolution-applier

docker-compose -f config/overview.yml up -d
docker-compose -f config/plugins.yml up -d

GATEWAY_HOST=$(docker inspect -f '{{ .NetworkSettings.Gateway }}' overview-network)

docker run \
  --env "DOCKER_HOST=$GATEWAY_HOST" \
  --link overview-database \
  --rm overview/plugin-setup

# Wait for the server to start
docker run \
  --link overview-web \
  --rm busybox \
  /bin/sh -c 'until $(echo | nc overview-web 9000 2>/dev/null); do sleep 1; done'

echo "Overview is running: browse to http://$GATEWAY_HOST:9000 to use it"
