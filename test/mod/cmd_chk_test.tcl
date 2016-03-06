#
package require tcltest

set root_dir [file dirname [file dirname [file dirname [info script]]]]
lappend ::auto_path [file join $root_dir "tcl"]

package require cmd_chk 1.0

################################################################################

# Write a test


################################################################################
::tcltest::cleanupTests
