#
package require tcltest

lappend ::auto_path [file join [file dirname [file dirname [info script]]] "tcl"]

package require cmd_chk 1.0

################################################################################

# Write a test


################################################################################
::tcltest::cleanupTests
