#
package require tcltest

set root_dir [file dirname [file dirname [file dirname [info script]]]]
lappend ::auto_path [file join $root_dir "tcl"]

package require args 1.0

################################################################################

::tcltest::test _parse {no optional args} -body {
    set args_def {
        "--arg1" {
            desc    "Argument 1"
        }
        "--arg2" {
            desc    "Argument 2"
        }
    }
    set cmd_argv [list "--arg1" "x" "--arg2" "y"]
    set cmd_argc [llength $cmd_argv]

    ::args::_parse $args_def $cmd_argv $cmd_argc
} -cleanup {
    unset args_def cmd_argv cmd_argc
} -result [list "arg1" "x" "arg2" "y"]

::tcltest::test _parse {optional arg and present} -body {
    set args_def {
        "--arg1" {
            desc    "Argument 1"
            default ""
        }
    }
    set cmd_argv [list "--arg1" "x"]
    set cmd_argc [llength $cmd_argv]

    ::args::_parse $args_def $cmd_argv $cmd_argc
} -cleanup {
    unset args_def cmd_argv cmd_argc
} -result [list "arg1" "x"]

::tcltest::test _parse {optional arg and missing} -body {
    set args_def {
        "--arg1" {
            desc    "Argument 1"
            default ""
        }
    }
    set cmd_argv [list]
    set cmd_argc [llength $cmd_argv]

    ::args::_parse $args_def $cmd_argv $cmd_argc
} -cleanup {
    unset args_def cmd_argv cmd_argc
} -result [list "arg1" ""]

::tcltest::test _parse {mandatory and optional args and present} -body {
    set args_def {
        "--arg1" {
            desc    "Argument 1"
            default ""
        }
        "--arg2" {
            desc    "Argument 2"
        }
    }
    set cmd_argv [list "--arg1" "x" "--arg2" "y"]
    set cmd_argc [llength $cmd_argv]

    ::args::_parse $args_def $cmd_argv $cmd_argc
} -cleanup {
    unset args_def cmd_argv cmd_argc
} -result [list "arg1" "x" "arg2" "y"]

::tcltest::test _parse {mandatory and optional args and opt missing} -body {
    set args_def {
        "--arg1" {
            desc    "Argument 1"
        }
        "--arg2" {
            desc    "Argument 2"
            default ""
        }
    }
    set cmd_argv [list "--arg1" "x"]
    set cmd_argc [llength $cmd_argv]

    ::args::_parse $args_def $cmd_argv $cmd_argc
} -cleanup {
    unset args_def cmd_argv cmd_argc
} -result [list "arg1" "x" "arg2" ""]

::tcltest::test _parse {mandatory arg is missing} -body {
    set args_def {"--arg1" {desc "Argument 1"}}
    set cmd_argv [list]
    set cmd_argc [llength $cmd_argv]

    if {[catch {
        ::args::_parse $args_def $cmd_argv $cmd_argc
    } msg]} {
        return 1
    } else {
        error "The test should have failed"
    }
} -cleanup {
    unset args_def cmd_argv cmd_argc
} -result 1



::tcltest::test _parse {list - mandatory and optional args and opt missing} -body {
    set args_def {
        "--arg1" {
            desc    "Argument 1"
        }
        "--arg2" {
            desc    "Argument 2"
            default ""
        }
    }
    set cmd_argv [list "--arg1" "x"]
    set cmd_argc [llength $cmd_argv]

    ::args::_parse $args_def $cmd_argv $cmd_argc
} -cleanup {
    unset args_def cmd_argv cmd_argc
} -result [list "arg1" "x" "arg2" ""]


::tcltest::test _parse {list - mandatory nargs 0 arg} -body {
    set args_def {
        "-s" {
            desc    "Argument S"
            nargs   0
        }
    }
    set cmd_argv [list "-s"]
    set cmd_argc [llength $cmd_argv]

    ::args::_parse $args_def $cmd_argv $cmd_argc
} -cleanup {
    unset args_def cmd_argv cmd_argc
} -result [list "s" 1]

################################################################################
::tcltest::cleanupTests
