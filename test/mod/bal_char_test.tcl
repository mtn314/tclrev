#
package require tcltest

set root_dir [file dirname [file dirname [file dirname [info script]]]]

lappend ::auto_path [file join $root_dir "tcl"]

package require bal_char 1.0


################################################################################

::tcltest::test is_brace_balanced {yes} -body {
    set string "{{{{{{{}}}}}}}"
    ::bal_char::is_brace_balanced $string
} -result {status 1 left 7 right 7}

::tcltest::test is_brace_balanced {yes with backslashed brace} -body {
    set string "\\\{"
    ::bal_char::is_brace_balanced $string
} -result {status 1 left 0 right 0}

::tcltest::test is_brace_balanced {yes with multiple backslashes} -body {
    set string "\\\\{}"
    ::bal_char::is_brace_balanced $string
} -result {status 1 left 1 right 1}

::tcltest::test is_brace_balanced {no - missing right brace} -body {
    set string "\{"
    ::bal_char::is_brace_balanced $string
} -result {status 0 left 1 right 0}

::tcltest::test is_brace_balanced {no - missing right brace} -body {
    set string "{\{}"
    ::bal_char::is_brace_balanced $string
} -result {status 0 left 2 right 1}

::tcltest::test is_brace_balanced {no - missing left brace} -body {
    set string "{\}}"
    ::bal_char::is_brace_balanced $string
} -result {status 0 left 1 right 2}


################################################################################
::tcltest::cleanupTests
