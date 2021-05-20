run() {
  EXITCODE=$?

  if [ "${1:-}" = --on-EXIT ]; then
    local __run__stdoutTempFile="${2:-}"
    local __run__stderrTempFile="${3:-}"
    local __run__existingExitTrap="${4:-}"
    local __run__setE="${5:-}"
    if [ -f "$__run__stdoutTempFile" ]; then
      STDOUT="$( < "$__run__stdoutTempFile" )" || echo "run: failed to read standard output from temporary file '$__run__stdoutTempFile' created using 'mktemp'" >&2
      echo "$STDOUT"
      rm "$__run__stdoutTempFile" || echo "run: failed to delete temporary file used for standard output '$__run__stdoutTempFile' created using 'mktemp'" >&2
    fi
    if [ -f "$__run__stderrTempFile" ]; then
      STDERR="$( < "$__run__stderrTempFile" )" || echo "run: failed to read standard error from temporary file '$__run__stderrTempFile' created using 'mktemp'" >&2
      echo "$STDERR" >&2
      rm "$__run__stderrTempFile" || echo "run: failed to delete temporary file used for standard error '$__run__stderrTempFile' created using 'mktemp'" >&2
    fi
    if [ -z "$__run__existingExitTrap" ]; then
      trap -- EXIT
    else
      trap "$__run__existingExitTrap" EXIT
    fi
    [ "$__run__setE" = true ] && set -e
    return 0
  else
    EXITCODE=
  fi

  STDOUT= STDERR=
  local -a __run__command=()
  local __run__printResults= __run__blockOpen= __run__blockClose= __run__runInSubShell= __run__stdoutTempFile __run__stderrTempFile __run__setE __run__existingExitTrap=

  local -r RUN_VERSION="1.2.0"
  [ "${1:-}" = --version ] && { echo "run version $RUN_VERSION"; return 0; }
  [ "${1:-}" = -p ] || [ "${1:-}" = --print ] && { __run__printResults=true; shift; }
  (( $# == 0 )) && return 0

  case "$1" in
    {)  __run__blockOpen={;  __run__blockClose=};  shift ;;
    [)  __run__blockOpen=[;  __run__blockClose=];  shift ;;
    {{) __run__blockOpen={{; __run__blockClose=}}; shift; __run__runInSubShell=true ;;
    [[) __run__blockOpen=[[; __run__blockClose=]]; shift; __run__runInSubShell=true ;;
    {{{)  __run__blockOpen={{{;  __run__blockClose=}}};  shift ;;
    [[[)  __run__blockOpen=[[[;  __run__blockClose=]]];  shift ;;
    {{{{) __run__blockOpen={{{{; __run__blockClose=}}}}; shift; __run__runInSubShell=true ;;
    [[[[) __run__blockOpen=[[[[; __run__blockClose=]]]]; shift; __run__runInSubShell=true ;;
    *)  __run__command+=("$@"); set -- ;;
  esac

  if [ -n "$__run__blockClose" ]; then
    while (( $# > 0 )) && [ "$1" != "$__run__blockClose" ]; do __run__command+=("$1"); shift; done
    (( $# == 0 )) && { echo "run: called with '$__run__blockOpen' but no closing '$__run__blockClose' found" >&2; return 2; } || shift;
    (( $# == 1 )) && { echo "run: unexpected argument '$*' after $__run__blockOpen ... $__run__blockClose" >&2; return 2; }
    (( $# > 1 ))  && { echo "run: unexpected arguments '$*' after $__run__blockOpen ... $__run__blockClose" >&2; return 2; }
  fi

  __run__stderrTempFile="$( mktemp )" || { echo "run: failed to create temporary file to store standard error using 'mktemp'" >&2; return 2; }
  if [ "$__run__runInSubShell" = true ]; then
    STDOUT="$( "${__run__command[@]}" 2>"$__run__stderrTempFile" )" && EXITCODE=$? || EXITCODE=$?
  else
    __run__stdoutTempFile="$( mktemp )" || { echo "run: failed to create temporary file to store standard output using 'mktemp'" >&2; return 2; }
    shopt -qo errexit && { __run__setE=true; set +e; }
    if [[ "$( trap -p EXIT )" != *"run --on-EXIT"* ]]; then
      [[ "$( trap -p EXIT )" =~ ^trap[[:space:]]--[[:space:]]\'(.*)\'[[:space:]]EXIT$ ]] && __run__existingExitTrap="${BASH_REMATCH[1]}"
      trap "run --on-EXIT \"$__run__stdoutTempFile\" \"$__run__stderrTempFile\" \"$__run__existingExitTrap\" \"$__run__setE\"; $__run__existingExitTrap" EXIT
    fi
    "${__run__command[@]}" 1>"$__run__stdoutTempFile" 2>"$__run__stderrTempFile" && EXITCODE=$? || EXITCODE=$?
    trap "$__run__existingExitTrap" EXIT
    [ "$__run__setE" = true ] && set -e
    STDOUT="$( < "$__run__stdoutTempFile" )" || echo "run: failed to read standard output from temporary file '$__run__stdoutTempFile' created using 'mktemp'" >&2
    [ -f "$__run__stdoutTempFile" ] && { rm "$__run__stdoutTempFile" || echo "run: failed to delete temporary file used for standard output '$__run__stdoutTempFile' created using 'mktemp'" >&2; }
  fi
  STDERR="$( < "$__run__stderrTempFile" )" || echo "run: failed to read standard error from temporary file '$__run__stderrTempFile' created using 'mktemp'" >&2
  [ -f "$__run__stderrTempFile" ] && { rm "$__run__stderrTempFile" || echo "run: failed to delete temporary file used for standard error '$__run__stderrTempFile' created using 'mktemp'" >&2; }

  if [ "$__run__printResults" = true ]; then
    printf "RUN: %s\nEXITCODE: %s\nSTDOUT: '%s'\nSTDERR: '%s'\n" "${__run__command[*]}" "$EXITCODE" "$STDOUT" "$STDERR"
  fi

  return $EXITCODE
}