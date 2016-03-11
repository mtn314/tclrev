# TCL Code Reviewer (alpha)

A basic implementation of a code reviewer for TCL.

Currently runs a set of regular expressions to check for some common (but sometimes hard to spot) errors.

## Unit testing

```
cd tclrev
tclsh test/runner.tcl
```

## Running

A usage message:

```
$ cd tclrev
$ tclsh tcl/main.tcl

Usage:
tclsh tcl/main.tcl
  args:
    --dir
         Path to the directory to check
    --level - Optional - default value: INFO
         Log Level: ERROR|WARN|INFO
    --s - Optional - default value: 0
         Scan symlinked directories: 1|0

```

## Example

```
$ cd tclrev
$ tclsh tcl/main.tcl --dir test_end2end/ --level WARN
WARN :: ---------------------------------
WARN :: test_end2end/expr_test.tcl:12
WARN :: expr's expression needs to be enclosed in {}
WARN :: expr 1 + 1
WARN ::
ERROR :: ---------------------------------
ERROR :: test_end2end/llength_test.tcl:16
ERROR :: The 1st llength arg must be a variable, command or list
ERROR :: llength lvar
ERROR ::
ERROR :: ---------------------------------
ERROR :: test_end2end/lsearch_test.tcl:18
ERROR :: The 1st lsearch arg must be a variable, command or list
ERROR :: lsearch lvar a
ERROR ::
ERROR :: ---------------------------------
ERROR :: test_end2end/unbalanced_braces.tcl:
ERROR :: Unbalanced braces
ERROR ::
```

## Valid commands checks

### RegEx Checks

| Check | Description |
| ---   | ---         |
| expr     | Check for curly brackets to avoid possible double execution. |
| llength  | The first argument must be a variable, command or list. |
| lsort    | The first argument must be a variable, command or list. |
| lsearch  | The first argument must be a variable, command or list. |
| lreverse | The first argument must be a variable, command or list. |
| lreplace | The first argument must be a variable, command or list. |
| lrange   | The first argument must be a variable, command or list. |
| lindex   | The first argument must be a variable, command or list. |

### Other Checks

| Check | Description |
| ---   | ---         |
| Brace check | Check balanced braces|

# Future (possible) functionality

| Check | Description |
| ---   | ---         |
| (TODO) Multiline | Commands split to multiple lines to contain "\" at the end of each line.|
| (TODO) Junit style reports | Could easily be integrated into CI tools|
