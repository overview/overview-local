#!/bin/bash

cd "$(dirname "$0")"

IMAGE_NAMES=(
  database
  message-broker
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
  overview-database
  overview-messagebroker
  overview-word-cloud
  overview-entity-filter
  overview-grep
  overview-file-browser
  overview-multi-search
  documentset-worker
  worker
  web
)

for image in ${IMAGE_NAMES[@]}; do
  docker pull overview/$image
done

for container in ${CONTAINER_NAMES[@]}; do
  docker rm -f $container
done

