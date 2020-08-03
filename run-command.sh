run() {
  local stdoutFile="$( mktemp )"
  local stderrFile="$( mktemp )"
  local _
  _="$( "$@" 1>"$stdoutFile" 2>"$stderrFile" )"
  EXIT_CODE=$?
  STDOUT="$( cat "$stdoutFile" )"
  STDERR="$( cat "$stderrFile" )"
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