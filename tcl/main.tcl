#

lappend ::auto_path [file normalize [file dirname [info script]]]

package require args 1.0
package require rev  1.0

dict set args_def "--dir"    desc "Path to the directory to check"

set args [::args::parse $args_def]

rev::main [dict get $args dir]
