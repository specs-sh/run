refute() {
  local REFUTE_VERSION=1.0.0
  if (( $# == 1 )) && [ "$1" = "--version" ]; then echo "refute version $REFUTE_VERSION"; return 0; fi
  if "$@"
  then
    echo "Expected to fail, but succeeded: \$ $*" >&2
    ${REFUTE_FAIL:-exit} 1
  else
    return 0
  fi
}