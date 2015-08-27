#!/bin/bash

docker create --name overview-database-data -v /var/lib/postgresql/data postgres:9.4
docker create --name overview-searchindex-data -v /usr/share/elasticsearch/data elasticsearch:1.7
docker create --name overview-blob-storage -v /var/lib/overview/blob-storage ubuntu:vivid


docker create --name overview-database --volumes-from overview-database-data overview/database
docker create --name overview-messagebroker  overview/message-broker
docker create --name overview-redis redis:2.8
docker create --name overview-searchindex \
  --volumes-from overview-searchindex-data \
   elasticsearch:1.7 elasticsearch \
  -Des.cluster.name="DevSearchIndex" \
  -Des.node.name="SearchIndex" \
  -Des.index.number_of_shards=1 



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
