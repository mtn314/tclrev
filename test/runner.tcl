#
package require tcltest

# If the app has more directories, we need to execute runAllTests for each of those
foreach dir [list [file dirname [info script]]] {
    puts ""
    puts "======== Directory: $dir ========"
    ::tcltest::configure -testdir $dir
    ::tcltest::configure -file "*_test.tcl"

    ::tcltest::runAllTests
}
