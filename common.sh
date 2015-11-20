# Behavior used by all our scripts

abort() {
  errcode=$?
  [ "$errcode" != "0" ] && echo "Command failed with error $errcode" >&2
  exit $errcode
}
trap 'abort' INT TERM EXIT
set -e
