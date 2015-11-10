#!/bin/bash

fatal() {
  echo >&2 "Error: $1"
  echo >&2 'Read the docs at http://github.com/overview/overview-local or'
  echo >&2 'contact us at info@overviewdocs.com for help.'
  exit 1
}

hash git 2>/dev/null || fatal 'You must install `git` and have it in your path to install Overview.'
hash docker 2>/dev/null || fatal 'You must install `docker` and have it in your path to install Overview.'
hash docker-compose 2>/dev/null || fatal 'You must install `docker-compose` and have it in your path to install Overview.'

echo "Changing to home directory..."
cd # We always install to the home directory; that's easier for new users.

echo "Removing any previous overview-local repository..."
rm -rf overview-local

echo "Downloading overview-local repository..."
git clone https://github.com/overview/overview-local.git

echo "Launching..."
overview-local/start

echo
echo "Here are some commands for future reference:"
echo
echo "overview-local/start: start Overview."
echo "overview-local/stop: stop Overview."
echo "overview-local/update: download a newer version of Overview."
echo "overview-local/tail-logs: show log messages as they appear (Ctrl+C to stop)."
echo "overview-local/dump-logs: dump past log messages."
