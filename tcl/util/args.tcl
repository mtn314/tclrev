#
package provide args 1.0

namespace eval ::args {}

#
# The procedure parses arguments configuration and shows usages if needed
#
# An example use:
#   package require args 1.0
#
#   dict set args_def "--dir"    desc "Path to the directory to check"
#   dict set args_def "--cmd_db" desc "Path to the file containing the command database"
#   dict set args_def "--cmd_db" default ""
#
#   set args [::args::parse $args_def]
#
# args:
#   args_def - a dictionary of predefined arguments, format:
#              "--key" desc "Some descritpion"
#              "--key" default "Some default value"
#                 - if default is specified, then the argument is treated as optional
# return:
#   returns a {key value key value} list where keys are without leading dashes
#
proc ::args::parse {args_def} {
    set app_args [list]

    set usage [::args::generate_usage $args_def]

    if {[catch {
        set app_args [::args::_parse $args_def $::argv $::argc]
    } msg]} {
        puts $usage
        puts "${msg}\n"
        exit
    }

    return $app_args
}


proc ::args::generate_usage {args_def} {
    set usage "Usage:\n"

    append usage [format "tclsh %s\n" [info script]]

    append usage "  args:\n"
    dict for {key val} $args_def {
        set opt_arg ""
        if {[dict exists $val default]} {
            set opt_arg " - Optional"
        }

        append usage [format "    %s%s\n" $key $opt_arg]
        append usage [format "         %s\n" [dict get $val desc]]
    }

    return $usage
}


proc ::args::_parse {args_def cmd_argv cmd_argc} {
    if {$cmd_argc % 2 != 0} {
        error "Error: Arguments must be pairs of --key value"
    }

    dict for {key val} $args_def {
        set found 0

        foreach {in_key in_val} $cmd_argv {
            if {$key == $in_key} {
                lappend app_args [string trimleft $in_key "-"] $in_val
                set found 1
                break
            }
        }

        if {[dict exists $val default] && $found == 0} {
            lappend app_args [string trimleft $key "-"] [dict get $args_def $key default]
        } elseif {$found == 0} {
            error "Error: $key is mandatory."
        }
    }

    return $app_args
}
