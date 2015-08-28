#!/bin/bash


## Create data containers
## These should only be created once. If they're deleted, all persistent storage
## used by Overview will be deleted.
## (calling twice is ok, will result in error message only)
 



DATABASE=$(docker ps -a -q --filter name=overview-database-data)
SEARCHINDEX=$(docker ps -a -q --filter name=overview-searchindex-data)
BLOBSTORAGE=$(docker ps -a -q --filter name=overview-blob-storage)


if [ -z "${DATABASE}" ]; then
  docker create --name overview-database-data -v /var/lib/postgresql/data postgres:9.4
fi

if [ -z "{SEARCHINDEX}" ]; then
  docker create --name overview-searchindex-data -v /usr/share/elasticsearch/data elasticsearch:1.7
fi

if [ -z "${BLOBSTORAGE}" ]; then
  docker create --name overview-blob-storage -v /var/lib/overview/blob-storage ubuntu:vivid
fi



## Create basic services used by Overview
docker create --name overview-database --volumes-from overview-database-data overview/database
docker create --name overview-messagebroker  overview/message-broker
docker create --name overview-redis redis:2.8
docker create --name overview-searchindex \
  --volumes-from overview-searchindex-data \
   elasticsearch:1.7 elasticsearch \
  -Des.cluster.name="DevSearchIndex" \
  -Des.node.name="SearchIndex" \
  -Des.index.number_of_shards=1 



## Create Overview services
docker create --name documentset-worker \
  --link overview-database \
  --link overview-messagebroker \
  --link overview-searchindex \
  --volumes-from overview-blob-storage \
  overview/documentset-worker

docker create --name worker \
  --link overview-database \
  --link overview-searchindex \
  --volumes-from overview-blob-storage \
  overview/worker

docker create --name web \
  --link overview-database \
  --link overview-messagebroker \
  --link overview-searchindex \
  --link overview-redis \
  --volumes-from overview-blob-storage \
  -p 9000:9000 \
  overview/web

## Create plugins

docker create --name overview-word-cloud \
  -p 3000:3000 \
  overview/overview-word-cloud

docker create --name overview-entity-filter \
  -p 3001:3000 \
  overview/overview-entity-filter

docker create --name overview-grep \
  -p 3002:3000 \
  overview/overview-grep

docker create --name overview-file-browser \
  -p 3003:3000 \
  overview/overview-file-browser

docker create --name overview-multi-search \
  -p 3004:3000 \
  overview/overview-multi-search




# Get images for one time commands

docker pull overview/db-evolution-applier
docker pull overview/plugin-setup

