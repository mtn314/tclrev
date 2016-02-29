# TCL Code Reviewer (alpha)

A basic implementation of a code reviewer for TCL.

Currently runs a set of regular expressions to check for some common (but sometimes hard to spot) errors.

## Unit testing

```
cd tclrev
tclsh test/runner.tcl
```

## Running

Run the below to get display a usage message.

```
cd tclrev
tclsh tcl/main.tcl --dir <some_directory>
```

## Example

```
$ cd tclrev
$ tclsh tcl/main.tcl --dir test_end2end/
WARN :: ---------------------------------
WARN :: test_end2end/expr_test.tcl - Line:10
WARN :: expr's expression needs to be enclosed in {}
WARN :: expr 1 + 1
WARN ::
WARN :: ---------------------------------
WARN :: test_end2end/llength_test.tcl - Line:16
WARN :: The 1st llength arg must be a variable, command or list
WARN :: llength lvar
WARN ::
WARN :: ---------------------------------
WARN :: test_end2end/lsearch_test.tcl - Line:16
WARN :: The 1st lsearch arg must be a variable, command or list
WARN :: lsearch lvar a
WARN ::
```

## Checks

| Check | Description |
| ---   | ---         |
| expr | Check for curly brackets to avoid possible double execution. |
| llength | The first argument must be a variable, command or list. |
| lsearch | The first argument must be a variable, command or list. |
| (TODO) Multiline | Commands split to multiple lines to contain "\" at the end of each line.|
