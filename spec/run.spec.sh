. "$( bx BxSH )"

PACKAGE_PATH=.:packages/

import @assert
import @expect
import @run

happyFunction() {
  echo "Happy STDOUT"
  echo "Happy STDERR" >&2
  if [ $# -gt 0 ]
  then
    echo "Happy called with $# arguments"
    echo "Happy called with $# arguments" >&2
    local arg
    for arg in "$@"
    do
      echo "Happy arg '$arg'"
      echo "Happy arg '$arg'" >&2
    done
  fi
  return 0
}

sadFunction() {
  echo "Sad STDOUT"
  echo "Sad STDERR" >&2
  if [ $# -gt 0 ]
  then
    echo "Sad called with $# arguments"
    echo "Sad called with $# arguments" >&2
    local arg
    for arg in "$@"
    do
      echo "Sad arg '$arg'"
      echo "Sad arg '$arg'" >&2
    done
  fi
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

@spec.get_version() {
  expect "$( run --version )" toMatch "run[[:space:]]version[[:space:]][0-9].[0-9].[0-9]"
}

@spec.can_get_exit_code() {
  assert run happyCommand
  expect "$EXITCODE" toEqual 0

  refute run sadCommand
  expect "$EXITCODE" toEqual 1

  refute run theAnswerCommand
  expect "$EXITCODE" toEqual 42
}

@spec.can_get_return_code() {
  assert run happyFunction
  expect "$EXITCODE" toEqual 0

  refute run sadFunction
  expect "$EXITCODE" toEqual 1

  refute run theAnswerFunction
  expect "$EXITCODE" toEqual 42
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

@spec.single_curly.can_get_STDOUT() {
  assert run { happyFunction }
  expect "$STDOUT" toEqual "Happy STDOUT"

  refute run { sadFunction }
  expect "$STDOUT" toEqual "Sad STDOUT"

  refute run { theAnswerFunction }
  expect "$STDOUT" toEqual "The Answer STDOUT"

  run { noSTDOUT }
  expect "$STDOUT" toBeEmpty

  run { noSTDERR }
  expect "$STDOUT" not toBeEmpty

  assert run { happyFunction hello world }
  expect "$STDOUT" toContain "Happy called with 2 arguments"
  expect "$STDOUT" toContain "Happy arg 'hello'"
  expect "$STDOUT" toContain "Happy arg 'world'"

  refute run { sadFunction hello "with spaces" world "even\nnewlines" }
  expect "$STDOUT" toContain "Sad called with 4 arguments"
  expect "$STDOUT" toContain "Sad arg 'hello'"
  expect "$STDOUT" toContain "Sad arg 'with spaces'"
  expect "$STDOUT" toContain "Sad arg 'world'"
  expect "$STDOUT" toContain "Sad arg 'even\nnewlines'"
}

@spec.single_bracket.can_get_STDOUT() {
  assert run [ happyFunction ]
  expect "$STDOUT" toEqual "Happy STDOUT"

  refute run [ sadFunction ]
  expect "$STDOUT" toEqual "Sad STDOUT"

  refute run [ theAnswerFunction ]
  expect "$STDOUT" toEqual "The Answer STDOUT"

  run [ noSTDOUT ]
  expect "$STDOUT" toBeEmpty

  run [ noSTDERR ]
  expect "$STDOUT" not toBeEmpty

  assert run [ happyFunction hello world ]
  expect "$STDOUT" toContain "Happy called with 2 arguments"
  expect "$STDOUT" toContain "Happy arg 'hello'"
  expect "$STDOUT" toContain "Happy arg 'world'"

  refute run [ sadFunction hello "with spaces" world "even\nnewlines" ]
  expect "$STDOUT" toContain "Sad called with 4 arguments"
  expect "$STDOUT" toContain "Sad arg 'hello'"
  expect "$STDOUT" toContain "Sad arg 'with spaces'"
  expect "$STDOUT" toContain "Sad arg 'world'"
  expect "$STDOUT" toContain "Sad arg 'even\nnewlines'"
}

@spec.double_curlies.can_get_STDOUT() {
  assert run {{ happyFunction }}
  expect "$STDOUT" toEqual "Happy STDOUT"

  refute run {{ sadFunction }}
  expect "$STDOUT" toEqual "Sad STDOUT"

  refute run {{ theAnswerFunction }}
  expect "$STDOUT" toEqual "The Answer STDOUT"

  run {{ noSTDOUT }}
  expect "$STDOUT" toBeEmpty

  run {{ noSTDERR }}
  expect "$STDOUT" not toBeEmpty

  assert run {{ happyFunction hello world }}
  expect "$STDOUT" toContain "Happy called with 2 arguments"
  expect "$STDOUT" toContain "Happy arg 'hello'"
  expect "$STDOUT" toContain "Happy arg 'world'"

  refute run {{ sadFunction hello "with spaces" world "even\nnewlines" }}
  expect "$STDOUT" toContain "Sad called with 4 arguments"
  expect "$STDOUT" toContain "Sad arg 'hello'"
  expect "$STDOUT" toContain "Sad arg 'with spaces'"
  expect "$STDOUT" toContain "Sad arg 'world'"
  expect "$STDOUT" toContain "Sad arg 'even\nnewlines'"
}

@spec.double_brackets.can_get_STDOUT() {
  assert run [[ happyFunction ]]
  expect "$STDOUT" toEqual "Happy STDOUT"

  refute run [[ sadFunction ]]
  expect "$STDOUT" toEqual "Sad STDOUT"

  refute run [[ theAnswerFunction ]]
  expect "$STDOUT" toEqual "The Answer STDOUT"

  run [[ noSTDOUT ]]
  expect "$STDOUT" toBeEmpty

  run [[ noSTDERR ]]
  expect "$STDOUT" not toBeEmpty

  assert run [[ happyFunction hello world ]]
  expect "$STDOUT" toContain "Happy called with 2 arguments"
  expect "$STDOUT" toContain "Happy arg 'hello'"
  expect "$STDOUT" toContain "Happy arg 'world'"

  refute run [[ sadFunction hello "with spaces" world "even\nnewlines" ]]
  expect "$STDOUT" toContain "Sad called with 4 arguments"
  expect "$STDOUT" toContain "Sad arg 'hello'"
  expect "$STDOUT" toContain "Sad arg 'with spaces'"
  expect "$STDOUT" toContain "Sad arg 'world'"
  expect "$STDOUT" toContain "Sad arg 'even\nnewlines'"
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

@spec.single_curly.can_get_STDERR() {
  assert run { happyFunction }
  expect "$STDERR" toEqual "Happy STDERR"

  refute run { sadFunction }
  expect "$STDERR" toEqual "Sad STDERR"

  refute run { theAnswerFunction }
  expect "$STDERR" toEqual "The Answer STDERR"

  run { noSTDERR }
  expect "$STDERR" toBeEmpty

  run { noSTDOUT }
  expect "$STDERR" not toBeEmpty

  assert run { happyFunction hello world }
  expect "$STDERR" toContain "Happy called with 2 arguments"
  expect "$STDERR" toContain "Happy arg 'hello'"
  expect "$STDERR" toContain "Happy arg 'world'"

  refute run { sadFunction hello "with spaces" world "even\nnewlines" }
  expect "$STDERR" toContain "Sad called with 4 arguments"
  expect "$STDERR" toContain "Sad arg 'hello'"
  expect "$STDERR" toContain "Sad arg 'with spaces'"
  expect "$STDERR" toContain "Sad arg 'world'"
  expect "$STDERR" toContain "Sad arg 'even\nnewlines'"
}

@spec.single_bracket.can_get_STDERR() {
  assert run [ happyFunction ]
  expect "$STDERR" toEqual "Happy STDERR"

  refute run [ sadFunction ]
  expect "$STDERR" toEqual "Sad STDERR"

  refute run [ theAnswerFunction ]
  expect "$STDERR" toEqual "The Answer STDERR"

  run [ noSTDERR ]
  expect "$STDERR" toBeEmpty

  run [ noSTDOUT ]
  expect "$STDERR" not toBeEmpty

  assert run [ happyFunction hello world ]
  expect "$STDERR" toContain "Happy called with 2 arguments"
  expect "$STDERR" toContain "Happy arg 'hello'"
  expect "$STDERR" toContain "Happy arg 'world'"

  refute run [ sadFunction hello "with spaces" world "even\nnewlines" ]
  expect "$STDERR" toContain "Sad called with 4 arguments"
  expect "$STDERR" toContain "Sad arg 'hello'"
  expect "$STDERR" toContain "Sad arg 'with spaces'"
  expect "$STDERR" toContain "Sad arg 'world'"
  expect "$STDERR" toContain "Sad arg 'even\nnewlines'"
}

@spec.double_curlies.can_get_STDERR() {
  assert run {{ happyFunction }}
  expect "$STDERR" toEqual "Happy STDERR"

  refute run {{ sadFunction }}
  expect "$STDERR" toEqual "Sad STDERR"

  refute run {{ theAnswerFunction }}
  expect "$STDERR" toEqual "The Answer STDERR"

  run {{ noSTDERR }}
  expect "$STDERR" toBeEmpty

  run {{ noSTDOUT }}
  expect "$STDERR" not toBeEmpty

  assert run {{ happyFunction hello world }}
  expect "$STDERR" toContain "Happy called with 2 arguments"
  expect "$STDERR" toContain "Happy arg 'hello'"
  expect "$STDERR" toContain "Happy arg 'world'"

  refute run {{ sadFunction hello "with spaces" world "even\nnewlines" }}
  expect "$STDERR" toContain "Sad called with 4 arguments"
  expect "$STDERR" toContain "Sad arg 'hello'"
  expect "$STDERR" toContain "Sad arg 'with spaces'"
  expect "$STDERR" toContain "Sad arg 'world'"
  expect "$STDERR" toContain "Sad arg 'even\nnewlines'"
}

@spec.double_brackets.can_get_STDERR() {
  assert run [[ happyFunction ]]
  expect "$STDERR" toEqual "Happy STDERR"

  refute run [[ sadFunction ]]
  expect "$STDERR" toEqual "Sad STDERR"

  refute run [[ theAnswerFunction ]]
  expect "$STDERR" toEqual "The Answer STDERR"

  run [[ noSTDERR ]]
  expect "$STDERR" toBeEmpty

  run [[ noSTDOUT ]]
  expect "$STDERR" not toBeEmpty

  assert run [[ happyFunction hello world ]]
  expect "$STDERR" toContain "Happy called with 2 arguments"
  expect "$STDERR" toContain "Happy arg 'hello'"
  expect "$STDERR" toContain "Happy arg 'world'"

  refute run [[ sadFunction hello "with spaces" world "even\nnewlines" ]]
  expect "$STDERR" toContain "Sad called with 4 arguments"
  expect "$STDERR" toContain "Sad arg 'hello'"
  expect "$STDERR" toContain "Sad arg 'with spaces'"
  expect "$STDERR" toContain "Sad arg 'world'"
  expect "$STDERR" toContain "Sad arg 'even\nnewlines'"
}

verifyRunsLocally() {
  foo="Haha! Changed by the command that was run!"
}

@spec.run.does_not_run_in_subshell() {
  local foo=5
  expect "$foo" toEqual 5

  run verifyRunsLocally

  expect "$foo" not toEqual 5
  expect "$foo" toEqual "Haha! Changed by the command that was run!"

  foo=5
  expect "$foo" toEqual 5

  run { verifyRunsLocally }

  expect "$foo" not toEqual 5
  expect "$foo" toEqual "Haha! Changed by the command that was run!"

  foo=5
  expect "$foo" toEqual 5

  run [ verifyRunsLocally ]

  expect "$foo" not toEqual 5
  expect "$foo" toEqual "Haha! Changed by the command that was run!"
}

@spec.run.can_be_run_in_subshell() {
  local foo=5

  run {{ verifyRunsLocally }}

  expect "$foo" toEqual 5

  run [[ verifyRunsLocally ]]

  expect "$foo" toEqual 5
}

@spec.curlies_or_brackets_not_closed() {
  expect [ run { hello ] toFail "'run' called with '{' block but no closing '}' found"
  expect [ run {{ hello ] toFail "'run' called with '{{' block but no closing '}}' found"
  expect { run [ hello } toFail "'run' called with '[' block but no closing ']' found"
  expect { run [[ hello } toFail "'run' called with '[[' block but no closing ']]' found"
}

@spec.curlies_or_brackets_with_extra_arguments() {
  expect [ run { ls } anotherArg ] toFail "'run' called with '{ ... }' block but unexpected argument found after block: 'anotherArg'"
  expect [ run {{ ls }} anotherArg ] toFail "'run' called with '{{ ... }}' block but unexpected argument found after block: 'anotherArg'"
  expect { run [ ls ] anotherArg } toFail "'run' called with '[ ... ]' block but unexpected argument found after block: 'anotherArg'"
  expect { run [[ ls ]] anotherArg } toFail "'run' called with '[[ ... ]]' block but unexpected argument found after block: 'anotherArg'"
}