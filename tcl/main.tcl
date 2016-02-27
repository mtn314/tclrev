#

lappend ::auto_path "."

package require rev 1.0

proc parse_args {} {
    set args [list]
    set usage "\n"
    append usage "tclsh main.tcl --dir <path_to_dir>"

    if {[llength $::argv] != 2} {
        puts $usage
        puts "Error: Missing arguments\n"
        exit
    }

    foreach {key val} $::argv {
        switch $key {
            --dir {
                lappend args [string trimleft $key "-"] $val
            }
            default {
                puts $usage
                puts "Error: Incorrect arguments\n"
                exit
            }
        }
    }

    return $args
}

set args [parse_args]

rev::main [dict get $args dir]
