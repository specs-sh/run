. "$( bx BxSH )"

PACKAGE_PATH=.:packages/

import @assert
import @expect
import @run-command

happyFunction() {
  echo "Happy STDOUT"
  echo "Happy STDERR" >&2
  return 0
}

sadFunction() {
  echo "Sad STDOUT"
  echo "Sad STDERR" >&2
  return 1
}

theAnswerFunction() {
  echo "The Answer STDOUT"
  echo "The Answer STDERR" >&2
  return 42
}

noSTDOUT() {
  echo "STDERR only, please!" >&2
  return 0
}

noSTDERR() {
  echo "STDOUT only, please!"
  return 0
}

PATH="$PATH:spec/bin"

@spec.can_get_exit_code() {
  assert run happyCommand
  expect "$EXIT_CODE" toEqual 0
  expect "$( EXIT_CODE )" toEqual 0

  refute run sadCommand
  expect "$EXIT_CODE" toEqual 1
  expect "$( EXIT_CODE )" toEqual 1

  refute run theAnswerCommand
  expect "$EXIT_CODE" toEqual 42
  expect "$( EXIT_CODE )" toEqual 42
}

@spec.can_get_return_code() {
  assert run happyFunction
  expect "$EXIT_CODE" toEqual 0
  expect "$( EXIT_CODE )" toEqual 0

  refute run sadFunction
  expect "$EXIT_CODE" toEqual 1
  expect "$( EXIT_CODE )" toEqual 1

  refute run theAnswerFunction
  expect "$EXIT_CODE" toEqual 42
  expect "$( EXIT_CODE )" toEqual 42
}

@spec.can_get_STDOUT() {
  assert run happyFunction
  expect "$STDOUT" toEqual "Happy STDOUT"
  expect "$( STDOUT )" toEqual "Happy STDOUT"

  refute run sadFunction
  expect "$STDOUT" toEqual "Sad STDOUT"
  expect "$( STDOUT )" toEqual "Sad STDOUT"

  refute run theAnswerFunction
  expect "$STDOUT" toEqual "The Answer STDOUT"
  expect "$( STDOUT )" toEqual "The Answer STDOUT"

  run noSTDOUT
  expect "$STDOUT" toBeEmpty
  expect "$( STDOUT )" toBeEmpty

  run noSTDERR
  expect "$STDOUT" not toBeEmpty
  expect "$( STDOUT )" not toBeEmpty
}

@spec.can_get_STDERR() {
  assert run happyFunction
  expect "$STDERR" toEqual "Happy STDERR"
  expect "$( STDERR )" toEqual "Happy STDERR"

  refute run sadFunction
  expect "$STDERR" toEqual "Sad STDERR"
  expect "$( STDERR )" toEqual "Sad STDERR"

  refute run theAnswerFunction
  expect "$STDERR" toEqual "The Answer STDERR"
  expect "$( STDERR )" toEqual "The Answer STDERR"

  run noSTDERR
  expect "$STDERR" toBeEmpty
  expect "$( STDERR )" toBeEmpty

  run noSTDOUT
  expect "$STDERR" not toBeEmpty
  expect "$( STDERR )" not toBeEmpty
}