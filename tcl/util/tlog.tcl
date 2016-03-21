#
package provide tlog 1.0

namespace eval ::tlog {
    variable LEVEL
    variable LEVELS

    dict set LEVELS ERROR 1
    dict set LEVELS WARN  2
    dict set LEVELS INFO  3
}

proc ::tlog::init {level} {
    variable LEVEL
    variable LEVELS

    if {![dict exists $LEVELS $level]} {
        ::error "Unknown log level: $level"
        exit
    }

    set LEVEL $level
}

proc ::tlog::error {msg} {
    ::tlog::_log ERROR $msg 31
}

proc ::tlog::warn {msg} {
    ::tlog::_log WARN $msg 36
}

proc ::tlog::info {msg} {
    ::tlog::_log INFO $msg 37
}

proc ::tlog::is_level_enabled {level} {
    variable LEVEL
    variable LEVELS

    if {[dict get $LEVELS $level] <= [dict get $LEVELS $LEVEL]} {
        return 1
    }
    return 0
}

proc ::tlog::_log {level msg color} {
    if {[::tlog::is_level_enabled $level]} {
        puts "\033\[01;${color}m${level}\033\[0m :: ${msg}"
    }
}
