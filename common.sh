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

# docker_compose: like "docker-compose" but with the arguments we want
docker_compose() {
  maybe_ssl1=""
  maybe_ssl2=""
  if grep -q -E '^OV_DOMAIN_NAME=.' "$(dirname "$0")"/config/overview.env; then
    maybe_ssl1="-f"
    maybe_ssl2="$(dirname "$0")"/config/overview-ssl.yml
  fi

  docker-compose \
    -f "$(dirname "$0")"/config/overview.yml \
    --project-name overviewlocal \
    $maybe_ssl1 $maybe_ssl2 \
    "$@"
}
