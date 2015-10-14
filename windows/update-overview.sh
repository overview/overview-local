#!/bin/bash


IMAGE_NAMES=(
  database
  db-evolution-applier
  plugin-setup
  overview-word-cloud
  overview-entity-filter
  overview-grep
  overview-file-browser
  overview-multi-search
  documentset-worker
  worker
  web
)

# names not preprended with overview
CONTAINER_NAMES=(
  web
  documentset-worker
  worker
  overview-database
  overview-redis
  overview-searchindex
  overview-word-cloud
  overview-entity-filter
  overview-grep
  overview-file-browser
  overview-multi-search
)

for image in ${IMAGE_NAMES[@]}; do
  docker pull overview/$image
done

for container in ${CONTAINER_NAMES[@]}; do
  echo -n "Deleting "
  docker rm -f $container
done

echo Restarting virtual host
docker-machine restart default


