#
package provide args 1.0

namespace eval ::args {}

#
# The procedure parses arguments configuration and shows usages if needed
#
# An example use:
#   package require args 1.0
#
#   set args_def {
#       "--dir" {
#           desc  "Path to the directory to check"
#           nargs 1
#       }
#       "--level" {
#           desc "Log Level: ERROR|WARN|INFO"
#           default INFO
#           nargs 1
#       }
#       "-s" {
#           desc "Scan symlinked directories"
#           nargs 0
#       }
# }
#
#   set args [::args::parse $args_def]
#
# args:
#   args_def - a list of predefined arguments, format:
#              "--key" {
#                      desc    "Some descritpion"
#                      default "Some default value"
#                      nargs   int
#              }
#           - if default is specified, then the argument is treated as optional
#           - nargs - number of values for the argument, if set to 0, then the arg
#                     is assumed to be a switch (1 if present, 0 otherwise)
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
            set opt_arg " - Optional - default value: [dict get $val default]"
        }

        append usage [format "    %s%s\n" $key $opt_arg]
        append usage [format "         %s\n" [dict get $val desc]]
    }

    return $usage
}


proc ::args::_parse {args_def cmd_argv cmd_argc} {
    foreach {key val} $args_def {
        set found 0
        set nargs 1
        if {[dict exists $val nargs]} {
            set nargs [dict get $val nargs]
        }

        for {set i 0} {$i < $cmd_argc} {incr i} {
            set in_key [lindex $cmd_argv $i]
            if {$key == $in_key} {
                if {$nargs > 0} {
                    # TODO support for $nargs > 1
                    incr i
                    lappend app_args [string trimleft $in_key "-"] [lindex $cmd_argv $i]
                } else {
                    lappend app_args [string trimleft $in_key "-"] 1
                }
                set found 1
                break
            }
        }

        if {$found == 0} {
            if {$nargs == 0} {
                lappend app_args [string trimleft $key "-"] 0
            } elseif {[dict exists $val default]} {
                lappend app_args [string trimleft $key "-"] [dict get $args_def $key default]
            } else {
                error "Error: $key is mandatory."
            }
        }
    }

    return $app_args
}
