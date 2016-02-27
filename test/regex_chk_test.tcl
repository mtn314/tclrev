#
package require tcltest

lappend ::auto_path [file join [file dirname [file dirname [info script]]] "tcl"]
puts $::auto_path

package require regex_chk 1.0


################################################################################

::tcltest::test is_line_to_skip {empty line} -body {
    set line {}
    ::regex_chk::is_line_to_skip $line
} -result 1

::tcltest::test is_line_to_skip {empty line} -body {
    set line {#}
    ::regex_chk::is_line_to_skip $line
} -result 1

::tcltest::test is_line_to_skip {empty line} -body {
    set line {proc something}
    ::regex_chk::is_line_to_skip $line
} -result 1

::tcltest::test is_line_to_skip {empty line} -body {
    set line {any_other_command}
    ::regex_chk::is_line_to_skip $line
} -result 0

################################################################################

::tcltest::test run_checks {empty line} -body {
    set line {}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::tcltest::test run_checks {expr - valid} -body {
    set line "expr {1+1}"
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {expr - missing {}} -body {
    set line "expr 1+1"
    ::regex_chk::run_checks $line
} -result [list status 0 msg "expr's expression needs to be enclosed in {}"]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::tcltest::test run_checks {lsearch - valid - variable} -body {
    set line {lsearch $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lsearch - valid - command} -body {
    set line {lsearch [list a b c] a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lsearch - valid - list} -body {
    set line {lsearch {a b c} a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lsearch - invalid - a word} -body {
    set line {lsearch lvar a}
    ::regex_chk::run_checks $line
} -result [list status 0 msg "The 1st lsearch arg must be a variable, command or list"]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::tcltest::test run_checks {llength - valid - variable} -body {
    set line {llength $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {llength - valid - command} -body {
    set line {llength [list a b c] a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {llength - valid - list} -body {
    set line {llength {a b c} a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {llength - invalid - a word} -body {
    set line {llength lvar a}
    ::regex_chk::run_checks $line
} -result [list status 0 msg "The 1st llength arg must be a variable, command or list"]

################################################################################
::tcltest::cleanupTests
