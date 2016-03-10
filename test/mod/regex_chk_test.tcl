#
package require tcltest

set root_dir [file dirname [file dirname [file dirname [info script]]]]
lappend ::auto_path [file join $root_dir "tcl"]

package require regex_chk 1.0


################################################################################

::tcltest::test is_line_to_skip {empty line} -setup {
    ::regex_chk::init
} -body {
    set line {}
    ::regex_chk::is_line_to_skip $line
} -result 1

::tcltest::test is_line_to_skip {empty line} -setup {
    ::regex_chk::init
} -body {
    set line {#}
    ::regex_chk::is_line_to_skip $line
} -result 1

::tcltest::test is_line_to_skip {empty line} -setup {
    ::regex_chk::init
} -body {
    set line {proc something}
    ::regex_chk::is_line_to_skip $line
} -result 1

::tcltest::test is_line_to_skip {empty line} -setup {
    ::regex_chk::init
} -body {
    set line {any_other_command}
    ::regex_chk::is_line_to_skip $line
} -result 0

################################################################################

::tcltest::test run_checks {empty line} -setup {
    ::regex_chk::init
} -body {
    set line {}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::tcltest::test run_checks {expr - valid} -setup {
    ::regex_chk::init
} -body {
    set line "expr {1+1}"
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {expr - missing {}} -setup {
    ::regex_chk::init
} -body {
    set line "expr 1+1"
    ::regex_chk::run_checks $line
} -result [list status 0 msg "expr's expression needs to be enclosed in {}" level WARN]

::tcltest::test run_checks {expr - valid} -setup {
    ::regex_chk::init
} -body {
    set line "set varexpr 1"
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::tcltest::test run_checks {lsearch - valid - variable} -setup {
    ::regex_chk::init
} -body {
    set line {lsearch $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lsearch - valid - command} -setup {
    ::regex_chk::init
} -body {
    set line {lsearch [list a b c] a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lsearch - valid - list} -setup {
    ::regex_chk::init
} -body {
    set line {lsearch {a b c} a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lsearch - valid with switch} -setup {
    ::regex_chk::init
} -body {
    set line {lsearch -exact $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lsearch - valid with -index switch} -setup {
    ::regex_chk::init
} -body {
    set line {lsearch -index 0 $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lsearch - valid with -index switch} -setup {
    ::regex_chk::init
} -body {
    set line {lsearch -start 1 $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lsearch - valid with -index switch} -setup {
    ::regex_chk::init
} -body {
    set line {lsearch -all -inline -not -exact {a b c a d e a f g a} a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lsearch - valid with a backslash (a string, not a command)} -setup {
    ::regex_chk::init
} -body {
    set line {lsearch \$lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lsearch - invalid - a word} -setup {
    ::regex_chk::init
} -body {
    set line {lsearch lvar a}
    ::regex_chk::run_checks $line
} -result [list status 0 msg "The 1st lsearch arg must be a variable, command or list" level ERROR]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# The below are just variants of the above more comprehensive cases

::tcltest::test run_checks {lsort - valid - variable} -setup {
    ::regex_chk::init
} -body {
    set line {lsort $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::tcltest::test run_checks {llength - valid - variable} -setup {
    ::regex_chk::init
} -body {
    set line {llength $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {llength - valid - command} -setup {
    ::regex_chk::init
} -body {
    set line {llength [list a b c] a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {llength - valid - list} -setup {
    ::regex_chk::init
} -body {
    set line {llength {a b c} a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {llength - invalid - a word} -setup {
    ::regex_chk::init
} -body {
    set line {llength lvar a}
    ::regex_chk::run_checks $line
} -result [list status 0 msg "The 1st llength arg must be a variable, command or list" level ERROR]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# The below are just variants of the above more comprehensive cases

::tcltest::test run_checks {lreverse - valid - variable} -setup {
    ::regex_chk::init
} -body {
    set line {lreverse $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lreplace - valid - variable} -setup {
    ::regex_chk::init
} -body {
    set line {lreplace $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lrange - valid - variable} -setup {
    ::regex_chk::init
} -body {
    set line {lrange $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

::tcltest::test run_checks {lindex - valid - variable} -setup {
    ::regex_chk::init
} -body {
    set line {lindex $lvar a}
    ::regex_chk::run_checks $line
} -result [list status 1 msg ""]

################################################################################
::tcltest::cleanupTests
