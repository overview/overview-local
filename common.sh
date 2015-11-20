# Behavior used by all our scripts

abort() {
  errcode=$?
  echo '`'"$BASH_COMMAND"'` failed with error '$? >&2
  exit $errcode
}
trap 'abort' ERR
set -e
