#

lappend ::auto_path [file normalize [file dirname [info script]]]

package require args 1.0
package require log  1.0
package require rev  1.0

dict set args_def "--dir"    desc "Path to the directory to check"
dict set args_def "--level"  desc "Log Level: ERROR|WARN|INFO"
dict set args_def "--level"  default INFO

set args [::args::parse $args_def]

::log::init [dict get $args level]
rev::main   [dict get $args dir]
