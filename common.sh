# Behavior used by all our scripts - trap errors and report to user if any command fails

abort() {
  errcode=$?
  [ "$errcode" != "0" ] && echo "Command failed with error $errcode" >&2
  exit $errcode
}
trap 'abort' INT TERM EXIT
set -e

# Use versioned dependency images. We run busybox+ubuntu from the command
# line, and their programs' calling conventions have been known to change.
BUSYBOX_IMAGE="library/busybox:1.27.2"
UBUNTU_IMAGE="library/ubuntu:17.10"

eval "$(grep -v -E '^#|^OV_WELCOME_BANNER|^$' "$(dirname "$0")"/config/overview.defaults.env | sed 's/^/export /')"
eval "$(grep -v -E '^#|^OV_WELCOME_BANNER|^$' "$(dirname "$0")"/config/overview.env | sed 's/^/export /')"
DOCKER_COMPOSE="docker-compose -f $(dirname "$0")/config/overview.yml --project-name overview-local"
grep -q -E '^OV_DOMAIN_NAME=.' "$(dirname "$0")/config/overview.env" && DOCKER_COMPOSE="$DOCKER_COMPOSE -f $(dirname "$0")/config/overview-ssl.yml" || true
