# 🚀 `run $command`

Test Command Output.

---

```sh
$ source "run-command.sh"

$ run ls

$ echo $?
0

$ echo "$EXIT_CODE"
0

$ EXIT_CODE
0

$ echo "$STDOUT"
foo
bar

$ STDOUT
foo
bar

$ echo "$STDERR"

$ STDERR
```

---

- The `run` function returns the underlying command's exit or return code
- The command or function's return code is put into an `$EXIT_CODE` variable
- The command or function's output is put into a `$STDOUT` variable
- The command or function's standard error is put into a `$STDERR` variable
- You can also get the return code by calling the `EXIT_CODE` function
- You can also get the output by calling the `STDOUT` function
- You can also get the standard error by calling the `STDERR` function
