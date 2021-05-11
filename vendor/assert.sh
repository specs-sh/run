assert() {
  local ASSERT_VERSION=1.0.0
  if (( $# == 1 )) && [ "$1" = "--version" ]; then echo "assert version $ASSERT_VERSION"; return 0; fi
  if "$@"
  then
    return 0
  else
    local -i __assert__exitCode=$?
    echo "Expected to succeed, but failed: \$ $*" >&2
    ${ASSERT_FAIL:-exit} $__assert__exitCode
  fi
}