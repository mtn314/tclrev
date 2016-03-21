#

lappend ::auto_path [file normalize [file dirname [info script]]]

package require args 1.0
package require tlog  1.0
package require rev  1.0

set args_def {
    "--dir" {
        desc "Path to the directory to check"
    }
    "--level" {
        desc "Log Level: ERROR|WARN|INFO"
        default INFO
    }
    "-s" {
        desc "Scan symlinked directories"
        nargs 0
    }
}

set args [::args::parse $args_def]

::tlog::init [dict get $args level]

::rev::main [dict get $args dir] [dict get $args s]
