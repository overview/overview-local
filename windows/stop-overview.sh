#!/bin/bash


docker stop \
  web \
  worker \
  documentset-worker

docker stop \
  overview-word-cloud \
  overview-entity-filter \
  overview-grep \
  overview-file-browser \
  overview-multi-search

docker stop \
  overview-searchindex \
  overview-redis \
  overview-database \
