#!/bin/bash


# The next release of docker-compose will allow environment
# variables to be expanded in the yml file...
echo DOCKER_HOST=$DOCKER_HOST > config/host.env

docker-compose -f config/services.yml up -d

sleep 5

docker-compose -f config/db-setup.yml up
docker-compose -f config/overview.yml up -d


docker-compose -f config/plugins.yml up -d

## Try to wait for server to start and then open 
## a browser window to the Overview url
docker run --name up-checker-web --env-file config/host.env --rm overview/up-checker


PLUGIN_HOST=$(echo ${DOCKER_HOST:-localhost} | sed 's/[a-zA-Z]*:\/\/\(.*\):.*/\1/')

url=http://${PLUGIN_HOST}:9000

## Only check for OS X and Ubuntu. Windows user must run a separate script
browser_path=$(which open || which xdg-open)

if [ -z "${browser_path}" ]; then
  echo Goto $url with your browser
else
  ${browser_path} $url
fi




