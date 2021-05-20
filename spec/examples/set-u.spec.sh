source run.sh

after() {
  echo "In 'after', the STDERR is: '$STDERR'"
}

spec.can.capture.set.u.errors() {
  run thisCausesSetUError
  echo "This should never be seen"
}

thisCausesSetUError() {
  set -u
  x="$UNSET_VAR"
}