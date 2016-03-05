#
package require tcltest

set test_root_dir [file dirname [info script]]
set dirs $test_root_dir
# Find all directories in the test directory
lappend dirs {*}[glob -directory $test_root_dir -types d *]

# Execute runAllTests for each of the directories that contain tcl tests
foreach dir $dirs {
    puts ""
    puts "======== Directory: $dir ========"
    ::tcltest::configure -testdir $dir
    ::tcltest::configure -file "*_test.tcl"

    ::tcltest::runAllTests
}
