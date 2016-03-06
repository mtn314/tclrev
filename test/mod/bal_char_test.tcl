#
package require tcltest

set root_dir [file dirname [file dirname [file dirname [info script]]]]

lappend ::auto_path [file join $root_dir "tcl"]

package require bal_char 1.0


################################################################################

::tcltest::test is_brace_balanced {yes} -body {
    set string "{{{{{{{}}}}}}}"
    ::bal_char::is_brace_balanced $string
} -result 1

::tcltest::test is_brace_balanced {yes with backslashed brace} -body {
    set string "\\\{"
    ::bal_char::is_brace_balanced $string
} -result 1

::tcltest::test is_brace_balanced {yes with multiple backslashes} -body {
    set string "\\\\{}"
    ::bal_char::is_brace_balanced $string
} -result 1

::tcltest::test is_brace_balanced {no - missing right brace} -body {
    set string "\{"
    ::bal_char::is_brace_balanced $string
} -result 0

::tcltest::test is_brace_balanced {no - missing right brace} -body {
    set string "{\{}"
    ::bal_char::is_brace_balanced $string
} -result 0

::tcltest::test is_brace_balanced {no - missing left brace} -body {
    set string "{\}}"
    ::bal_char::is_brace_balanced $string
} -result 0


################################################################################
::tcltest::cleanupTests
