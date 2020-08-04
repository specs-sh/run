run() {
  VERSION="0.2.0"
  [[ "$1" = "--version" ]] && { echo "run version $VERSION"; return 0; }
  local runInSubShell=false
  if [[ "$1" = "--" ]]
  then
    runInSubShell=true
    shift
  fi
  local stdoutFile="$( mktemp )"
  local stderrFile="$( mktemp )"
  local _
  if [ "$runInSubShell" = "true" ]
  then
    _="$( "$@" 1>"$stdoutFile" 2>"$stderrFile" )"
    EXIT_CODE=$?
  else
    "$@" 1>"$stdoutFile" 2>"$stderrFile"
    EXIT_CODE=$?
  fi
  STDOUT="$( cat "$stdoutFile" )"
  STDERR="$( cat "$stderrFile" )"
  OUTPUT="${STDOUT}\n${STDERR}"
  rm -f "$stdoutFile"
  rm -f "$stderrFile"
  return $EXIT_CODE
}

EXIT_CODE() {
  printf "$EXIT_CODE"
}

STDOUT() {
  printf "$STDOUT"
}

STDERR() {
  printf "$STDERR"
}

OUTPUT() {
  printf "$OUTPUT"
}