. "$( bx BxSH )"

PACKAGE_PATH=.:packages/

import @assert
import @expect
import @run

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

@spec.getVersion() {
  expect "$( run --version )" toMatch "run[[:space:]]version[[:space:]][0-9].[0-9].[0-9]"
}

@spec.can_get_exit_code() {
  assert run happyCommand
  expect "$EXIT_CODE" toEqual 0

  refute run sadCommand
  expect "$EXIT_CODE" toEqual 1

  refute run theAnswerCommand
  expect "$EXIT_CODE" toEqual 42
}

@spec.can_get_return_code() {
  assert run happyFunction
  expect "$EXIT_CODE" toEqual 0

  refute run sadFunction
  expect "$EXIT_CODE" toEqual 1

  refute run theAnswerFunction
  expect "$EXIT_CODE" toEqual 42
}

@spec.can_get_STDOUT() {
  assert run happyFunction
  expect "$STDOUT" toEqual "Happy STDOUT"

  refute run sadFunction
  expect "$STDOUT" toEqual "Sad STDOUT"

  refute run theAnswerFunction
  expect "$STDOUT" toEqual "The Answer STDOUT"

  run noSTDOUT
  expect "$STDOUT" toBeEmpty

  run noSTDERR
  expect "$STDOUT" not toBeEmpty
}

@spec.can_get_STDERR() {
  assert run happyFunction
  expect "$STDERR" toEqual "Happy STDERR"

  refute run sadFunction
  expect "$STDERR" toEqual "Sad STDERR"

  refute run theAnswerFunction
  expect "$STDERR" toEqual "The Answer STDERR"

  run noSTDERR
  expect "$STDERR" toBeEmpty

  run noSTDOUT
  expect "$STDERR" not toBeEmpty
}

@spec.can_get_OUTPUT() {
  assert run happyFunction
  expect "$OUTPUT" toEqual "Happy STDOUT\nHappy STDERR"

  refute run sadFunction
  expect "$OUTPUT" toEqual "Sad STDOUT\nSad STDERR"

  refute run theAnswerFunction
  expect "$OUTPUT" toEqual "The Answer STDOUT\nThe Answer STDERR"

  run noSTDERR
  expect "$OUTPUT" toEqual "STDOUT only, please!\n"

  run noSTDOUT
  expect "$OUTPUT" toEqual "\nSTDERR only, please!"
}

verifyRunsLocally() {
  foo="Haha! Changed by the command that was run!"
}

@spec.run.does_not_run_in_subshell() {
  local foo=5

  run verifyRunsLocally

  expect "$foo" not toEqual 5
  expect "$foo" toEqual "Haha! Changed by the command that was run!"
}

@spec.run.can_be_run_in_subshell() {
  local foo=5

  run -- verifyRunsLocally

  expect "$foo" toEqual 5
}

@pending.can_run_using_curl_brace_syntax() {
  :
}

@pending.can_run_in_subshell_using_double_curly_braces() {
  :
}