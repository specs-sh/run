---
---

{% raw %}
# 🚀 `run $command`

> _Simplest possible `run` command for beautiful shell script tests!_

---

 - **Simple interface** for **running commands** or functions
 - Stores return or **exit code** in easy-to-use variable
 - Stores **standard output** and **error output** in easy-to-use variables
 - Runs command in either **current shell** or runs in a **subshell**

---

Download the [latest version](https://github.com/specs-sh/run.sh/archive/v1.0.0.tar.gz) or install via:

#### `curl -o- https://run.specs.sh/install.sh | bash`

Source the downloaded `run.sh` script to use in your tests:

```sh
source "run.sh"

run echo "Hello, world"

printf "$STDOUT"
# => "Hello, world"

printf "$STDERR"
# => ""

printf "$EXITCODE"
# => "0"
```

---

## run $command

### `$STDOUT`

To get the standard output, check the `$STDOUT` variable:

```sh
run echo "Hello, world"

printf "$STDOUT"
# => Hello, world
```

### `$STDERR`

To get the standard output, check the `$STDERR` variable:

```sh
run foo "This command does not exist"

printf "$STDERR"
# => foo: command not found
```

### `$EXITCODE`

To get the standard output, check the `$EXITCODE` variable:

```sh
run echo "Hello, world"

printf $EXITCODE
# => 0
```

```sh
run foo "This command does not exist"

printf $EXITCODE
# => 127
```

### `{ Current Shell }` or `{{ Subshell }}`

To run a function or command in the **current shell**:

 - Call normally (**no curly braces** / **no brackets**)
   ```sh
   run echo "Hello world" # <--- runs in current shell
   ```

Alternatively, to run a function or command in the **current shell**:

 - Call and wrap with a **single curly braces** or **single brackets**
   ```sh
   run { echo "Hello world" } # <--- runs in current shell
   run [ echo "Hello world" ] # <--- runs in current shell 
   ```

To run a function or command in a **subshell**:

 - Call and wrap with **double curly braces** or **double brackets**:
   ```sh
   run {{ echo "Hello world" }} # <--- runs in a SUBSHELL
   run [[ echo "Hello world" ]] # <--- runs in a SUBSHELL
   ```

#### ℹ️ Subshells

Commands run inside subshells have access to all local variables but changes are not reflected in the outer shell:

- ```sh
  setX() { x="$1"; }
  x=5
  
  run {{ setX 42 }} # <--- run in subshell
  printf "$x"
  # => 5            # <--- value of 'x' is still 5
  
  run setX 42       # <--- run in current shell
  printf "$x"
  # => 42           # <--- value of 'x' changed to '42'
  ```

> `run.sh` supports both braces and brackets to support commands which use brackets or braces as arguments.
>
> To call the `[` shell builtin function, you must wrap the command in braces: `run { [ 1 -eq 2 ] }`


{% endraw %}