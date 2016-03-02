#
package provide log 1.0

namespace eval ::log {
    variable LEVEL
    variable LEVELS

    dict set LEVELS ERROR 1
    dict set LEVELS WARN  2
    dict set LEVELS INFO  3
}

proc ::log::init {level} {
    variable LEVEL
    variable LEVELS

    if {![dict exists $LEVELS $level]} {
        ::error "Unknown log level: $level"
        exit
    }

    set LEVEL $level
}

proc ::log::error {msg} {
    ::log::_log ERROR $msg
}

proc ::log::warn {msg} {
    ::log::_log WARN $msg
}

proc ::log::info {msg} {
    ::log::_log INFO $msg
}

proc ::log::_log {level msg} {
    variable LEVEL
    variable LEVELS

    if {[dict get $LEVELS $level] <= [dict get $LEVELS $LEVEL]} {
        puts "$level :: $msg"
    }
}
