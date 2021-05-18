source run.sh
source vendor/assert.sh
source vendor/refute.sh

PATH="$PATH:${BASH_SOURCE[0]%/*}/bin"

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

spec.get.version() {
  [[ "$( run --version )" =~ run[[:space:]]version[[:space:]][0-9].[0-9].[0-9] ]]
}

spec.zero.arguments() {
  assert run
}

spec.can_get_exit_code() {
  assert run happyCommand
  (( EXITCODE == 0 ))

  refute run sadCommand
  (( EXITCODE == 1 ))

  refute run theAnswerCommand
  (( EXITCODE == 42 ))
}

spec.can.get.return.code() {
  assert run happyFunction
  (( EXITCODE == 0 ))

  refute run sadFunction
  (( EXITCODE == 1 ))

  refute run theAnswerFunction
  (( EXITCODE == 42 ))
}

spec.can.get.STDOUT() {
  assert run happyFunction
  [ "$STDOUT" = "Happy STDOUT" ]

  refute run sadFunction
  [ "$STDOUT" = "Sad STDOUT" ]

  refute run theAnswerFunction
  [ "$STDOUT" = "The Answer STDOUT" ]

  run noSTDOUT
  [ -z "$STDOUT" ]

  run noSTDERR
  [ -n "$STDOUT" ]
}

spec.single.curly.can.get.STDOUT() {
  assert run { happyFunction }
  [ "$STDOUT" = "Happy STDOUT" ]

  refute run { sadFunction }
  [ "$STDOUT" = "Sad STDOUT" ]

  refute run { theAnswerFunction }
  [ "$STDOUT" = "The Answer STDOUT" ]

  run { noSTDOUT }
  [ -z "$STDOUT" ]

  run { noSTDERR }
  [ -n "$STDOUT" ]

  assert run { happyFunction hello world }
  [[ "$STDOUT" = *"Happy called with 2 arguments"* ]]
  [[ "$STDOUT" = *"Happy arg 'hello'"* ]]
  [[ "$STDOUT" = *"Happy arg 'world'"* ]]

  refute run { sadFunction hello "with spaces" world "even\nnewlines" }
  [[ "$STDOUT" = *"Sad called with 4 arguments"* ]]
  [[ "$STDOUT" = *"Sad arg 'hello'"* ]]
  [[ "$STDOUT" = *"Sad arg 'with spaces'"* ]]
  [[ "$STDOUT" = *"Sad arg 'world'"* ]]
  [[ "$STDOUT" = *"Sad arg 'even\nnewlines'"* ]]
}

spec.single.bracket.can.get.STDOUT() {
  assert run [ happyFunction ]
  [ "$STDOUT" = "Happy STDOUT" ]

  refute run [ sadFunction ]
  [ "$STDOUT" = "Sad STDOUT" ]

  refute run [ theAnswerFunction ]
  [ "$STDOUT" = "The Answer STDOUT" ]

  run [ noSTDOUT ]
  [ -z "$STDOUT" ]

  run [ noSTDERR ]
  [ -n "$STDOUT" ]

  assert run [ happyFunction hello world ]
  [[ "$STDOUT" = *"Happy called with 2 arguments"* ]]
  [[ "$STDOUT" = *"Happy arg 'hello'"* ]]
  [[ "$STDOUT" = *"Happy arg 'world'"* ]]

  refute run [ sadFunction hello "with spaces" world "even\nnewlines" ]
  [[ "$STDOUT" = *"Sad called with 4 arguments"* ]]
  [[ "$STDOUT" = *"Sad arg 'hello'"* ]]
  [[ "$STDOUT" = *"Sad arg 'with spaces'"* ]]
  [[ "$STDOUT" = *"Sad arg 'world'"* ]]
  [[ "$STDOUT" = *"Sad arg 'even\nnewlines'"* ]]
}

spec.double.curlies.can.get.STDOUT() {
  assert run {{ happyFunction }}
  [ "$STDOUT" = "Happy STDOUT" ]

  refute run {{ sadFunction }}
  [ "$STDOUT" = "Sad STDOUT" ]

  refute run {{ theAnswerFunction }}
  [ "$STDOUT" = "The Answer STDOUT" ]

  run {{ noSTDOUT }}
  [ -z "$STDOUT" ]

  run {{ noSTDERR }}
  [ -n "$STDOUT" ]

  assert run {{ happyFunction hello world }}
  [[ "$STDOUT" = *"Happy called with 2 arguments"* ]]
  [[ "$STDOUT" = *"Happy arg 'hello'"* ]]
  [[ "$STDOUT" = *"Happy arg 'world'"* ]]

  refute run {{ sadFunction hello "with spaces" world "even\nnewlines" }}
  [[ "$STDOUT" = *"Sad called with 4 arguments"* ]]
  [[ "$STDOUT" = *"Sad arg 'hello'"* ]]
  [[ "$STDOUT" = *"Sad arg 'with spaces'"* ]]
  [[ "$STDOUT" = *"Sad arg 'world'"* ]]
  [[ "$STDOUT" = *"Sad arg 'even\nnewlines'"* ]]
}

spec.double.brackets.can.get.STDOUT() {
  assert run [[ happyFunction ]]
  [ "$STDOUT" = "Happy STDOUT" ]

  refute run [[ sadFunction ]]
  [ "$STDOUT" = "Sad STDOUT" ]

  refute run [[ theAnswerFunction ]]
  [ "$STDOUT" = "The Answer STDOUT" ]

  run [[ noSTDOUT ]]
  [ -z "$STDOUT" ]

  run [[ noSTDERR ]]
  [ -n "$STDOUT" ]

  assert run [[ happyFunction hello world ]]
  [[ "$STDOUT" = *"Happy called with 2 arguments"* ]]
  [[ "$STDOUT" = *"Happy arg 'hello'"* ]]
  [[ "$STDOUT" = *"Happy arg 'world'"* ]]

  refute run [[ sadFunction hello "with spaces" world "even\nnewlines" ]]
  [[ "$STDOUT" = *"Sad called with 4 arguments"* ]]
  [[ "$STDOUT" = *"Sad arg 'hello'"* ]]
  [[ "$STDOUT" = *"Sad arg 'with spaces'"* ]]
  [[ "$STDOUT" = *"Sad arg 'world'"* ]]
  [[ "$STDOUT" = *"Sad arg 'even\nnewlines'"* ]]
}

spec.can.get.STDERR() {
  assert run happyFunction
  [ "$STDERR" = "Happy STDERR" ]

  refute run sadFunction
  [ "$STDERR" = "Sad STDERR" ]

  refute run theAnswerFunction
  [ "$STDERR" = "The Answer STDERR" ]

  run noSTDERR
  [ -z "$STDERR" ]

  run noSTDOUT
  [ -n "$STDERR" ]
}

spec.single.curly.can.get.STDERR() {
  assert run { happyFunction }
  [ "$STDERR" = "Happy STDERR" ]

  refute run { sadFunction }
  [ "$STDERR" = "Sad STDERR" ]

  refute run { theAnswerFunction }
  [ "$STDERR" = "The Answer STDERR" ]

  run { noSTDERR }
  [ -z "$STDERR" ]

  run { noSTDOUT }
  [ -n "$STDERR" ]

  assert run { happyFunction hello world }
  [[ "$STDERR" = *"Happy called with 2 arguments"* ]]
  [[ "$STDERR" = *"Happy arg 'hello'"* ]]
  [[ "$STDERR" = *"Happy arg 'world'"* ]]

  refute run { sadFunction hello "with spaces" world "even\nnewlines" }
  [[ "$STDERR" = *"Sad called with 4 arguments"* ]]
  [[ "$STDERR" = *"Sad arg 'hello'"* ]]
  [[ "$STDERR" = *"Sad arg 'with spaces'"* ]]
  [[ "$STDERR" = *"Sad arg 'world'"* ]]
  [[ "$STDERR" = *"Sad arg 'even\nnewlines'"* ]]
}

spec.single.bracket.can.get.STDERR() {
  assert run [ happyFunction ]
  [ "$STDERR" = "Happy STDERR" ]

  refute run [ sadFunction ]
  [ "$STDERR" = "Sad STDERR" ]

  refute run [ theAnswerFunction ]
  [ "$STDERR" = "The Answer STDERR" ]

  run [ noSTDERR ]
  [ -z "$STDERR" ]

  run [ noSTDOUT ]
  [ -n "$STDERR" ]

  assert run [ happyFunction hello world ]
  [[ "$STDERR" = *"Happy called with 2 arguments"* ]]
  [[ "$STDERR" = *"Happy arg 'hello'"* ]]
  [[ "$STDERR" = *"Happy arg 'world'"* ]]

  refute run [ sadFunction hello "with spaces" world "even\nnewlines" ]
  [[ "$STDERR" = *"Sad called with 4 arguments"* ]]
  [[ "$STDERR" = *"Sad arg 'hello'"* ]]
  [[ "$STDERR" = *"Sad arg 'with spaces'"* ]]
  [[ "$STDERR" = *"Sad arg 'world'"* ]]
  [[ "$STDERR" = *"Sad arg 'even\nnewlines'"* ]]
}

spec.double.curlies.can.get.STDERR() {
  assert run {{ happyFunction }}
  [ "$STDERR" = "Happy STDERR" ]

  refute run {{ sadFunction }}
  [ "$STDERR" = "Sad STDERR" ]

  refute run {{ theAnswerFunction }}
  [ "$STDERR" = "The Answer STDERR" ]

  run {{ noSTDERR }}
  [ -z "$STDERR" ]

  run {{ noSTDOUT }}
  [ -n "$STDERR" ]

  assert run {{ happyFunction hello world }}
  [[ "$STDERR" = *"Happy called with 2 arguments"* ]]
  [[ "$STDERR" = *"Happy arg 'hello'"* ]]
  [[ "$STDERR" = *"Happy arg 'world'"* ]]

  refute run {{ sadFunction hello "with spaces" world "even\nnewlines" }}
  [[ "$STDERR" = *"Sad called with 4 arguments"* ]]
  [[ "$STDERR" = *"Sad arg 'hello'"* ]]
  [[ "$STDERR" = *"Sad arg 'with spaces'"* ]]
  [[ "$STDERR" = *"Sad arg 'world'"* ]]
  [[ "$STDERR" = *"Sad arg 'even\nnewlines'"* ]]
}

spec.double.brackets.can.get.STDERR() {
  assert run [[ happyFunction ]]
  [ "$STDERR" = "Happy STDERR" ]

  refute run [[ sadFunction ]]
  [ "$STDERR" = "Sad STDERR" ]

  refute run [[ theAnswerFunction ]]
  [ "$STDERR" = "The Answer STDERR" ]

  run [[ noSTDERR ]]
  [ -z "$STDERR" ]

  run [[ noSTDOUT ]]
  [ -n "$STDERR" ]

  assert run [[ happyFunction hello world ]]
  [[ "$STDERR" = *"Happy called with 2 arguments"* ]]
  [[ "$STDERR" = *"Happy arg 'hello'"* ]]
  [[ "$STDERR" = *"Happy arg 'world'"* ]]

  refute run [[ sadFunction hello "with spaces" world "even\nnewlines" ]]
  [[ "$STDERR" = *"Sad called with 4 arguments"* ]]
  [[ "$STDERR" = *"Sad arg 'hello'"* ]]
  [[ "$STDERR" = *"Sad arg 'with spaces'"* ]]
  [[ "$STDERR" = *"Sad arg 'world'"* ]]
  [[ "$STDERR" = *"Sad arg 'even\nnewlines'"* ]]
}

verifyRunsLocally() {
  foo="Haha! Changed by the command that was run!"
}

spec.run.does.not.run.in.subshell() {
  local foo=5
  [ "$foo" = 5 ]

  run verifyRunsLocally

  [ "$foo" != 5 ]
  [ "$foo" = "Haha! Changed by the command that was run!" ]

  foo=5
  [ "$foo" = 5 ]

  run { verifyRunsLocally }

  [ "$foo" != 5 ]
  [ "$foo" = "Haha! Changed by the command that was run!" ]

  foo=5
  [ "$foo" = 5 ]

  run [ verifyRunsLocally ]

  [ "$foo" != 5 ]
  [ "$foo" = "Haha! Changed by the command that was run!" ]

  foo=5
  [ "$foo" = 5 ]

  run [[[ verifyRunsLocally ]]]

  [ "$foo" != 5 ]
  [ "$foo" = "Haha! Changed by the command that was run!" ]

  foo=5
  [ "$foo" = 5 ]

  run {{{ verifyRunsLocally }}}

  [ "$foo" != 5 ]
  [ "$foo" = "Haha! Changed by the command that was run!" ]
}

spec.run.can.be.run.in.subshell() {
  local foo=5

  run {{ verifyRunsLocally }}
  [ "$foo" = 5 ]

  run [[ verifyRunsLocally ]]
  [ "$foo" = 5 ]

  run [[[[ verifyRunsLocally ]]]]
  [ "$foo" = 5 ]

  run {{{{ verifyRunsLocally }}}}
  [ "$foo" = 5 ]
}

spec.curlies.or.brackets.not.closed() {
  refute run run { hello ]
  [[ "$STDERR" = *"run: called with '{' but no closing '}' found"* ]]
  refute run run {{ hello ]
  [[ "$STDERR" = *"run: called with '{{' but no closing '}}' found"* ]]
  refute run run [ hello ]]
  [[ "$STDERR" = *"run: called with '[' but no closing ']' found"* ]]
  refute run run [[ hello ]
  [[ "$STDERR" = *"run: called with '[[' but no closing ']]' found"* ]]
  refute run run [[[ hello ]
  [[ "$STDERR" = *"run: called with '[[[' but no closing ']]]' found"* ]]
  refute run run [[[[ hello ]
  [[ "$STDERR" = *"run: called with '[[[[' but no closing ']]]]' found"* ]]
  refute run run {{{ hello ]
  [[ "$STDERR" = *"run: called with '{{{' but no closing '}}}' found"* ]]
  refute run run {{{{ hello ]
  [[ "$STDERR" = *"run: called with '{{{{' but no closing '}}}}' found"* ]]
}

spec.curlies.or.brackets.with.extra.arguments() {
  refute run run { ls } extra
  [[ "$STDERR" = *"run: unexpected argument 'extra' after { ... }"* ]]
  refute run run [[ ls ]] hello world
  [[ "$STDERR" = *"run: unexpected arguments 'hello world' after [[ ... ]]"* ]]
}

spec.can.print.run.info() {
  assert run echo Hello
  [[ "$STDOUT" != *"RUN: echo hello"* ]]
  [[ "$STDOUT" != *"EXITCODE: 0"* ]]
  [[ "$STDOUT" != *"STDOUT: 'Hello'"* ]]
  [[ "$STDOUT" != *"STDERR: ''"* ]]

  assert run run -p echo Hello
  [[ "$STDOUT" = *"RUN: echo Hello"* ]]
  [[ "$STDOUT" = *"EXITCODE: 0"* ]]
  [[ "$STDOUT" = *"STDOUT: 'Hello'"* ]]
  [[ "$STDOUT" = *"STDERR: ''"* ]]

  assert run run --print echo "Hello, world!"
  [[ "$STDOUT" = *"RUN: echo Hello, world!"* ]]
  [[ "$STDOUT" = *"EXITCODE: 0"* ]]
  [[ "$STDOUT" = *"STDOUT: 'Hello, world!'"* ]]
  [[ "$STDOUT" = *"STDERR: ''"* ]]

  assert run run -p echoToStderr Hello
  [[ "$STDOUT" = *"RUN: echoToStderr Hello"* ]]
  [[ "$STDOUT" = *"EXITCODE: 0"* ]]
  [[ "$STDOUT" = *"STDOUT: ''"* ]]
  [[ "$STDOUT" = *"STDERR: 'Hello'"* ]]
}

echoToStderr() {
  echo "$@" >&2
}