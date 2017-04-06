# Behavior used by all our scripts - trap errors and report to user if any command fails

abort() {
  errcode=$?
  [ "$errcode" != "0" ] && echo "Command failed with error $errcode" >&2
  exit $errcode
}
trap 'abort' INT TERM EXIT
set -e
