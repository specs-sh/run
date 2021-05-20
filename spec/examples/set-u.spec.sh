source run.sh

after() {
  echo "In 'after', the STDERR is: '$STDERR'"
  echo "In 'after', the STDOUT is: '$STDOUT'"
  echo "In 'after', the EXITCODE is: $EXITCODE"
}

spec.can.capture.set.u.errors() {
  run thisCausesSetUError
  echo "This should never be seen"
}

thisCausesSetUError() {
  set -u
  echo Hello
  x="$UNSET_VAR"
}