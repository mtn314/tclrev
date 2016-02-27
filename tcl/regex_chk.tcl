#
package provide regex_chk 1.0

namespace eval ::regex_chk {
    # (\\\n)?[\s]* - to allow for multi line matching

    dict set rule line_chk {expr[\s]+}
    dict set rule rule     {expr[\s]+(\\\n)?[\s]*\{}
    dict set rule msg      "expr's expression needs to be enclosed in {}"
    lappend RULES $rule

    dict set rule line_chk {lsearch[\s]+}
    # [\[\{\"\$] - is to check if we have a command, list or a variable as the first arg
    dict set rule rule     {lsearch[\s]+(\\\n)?[\s]*[\[\{\"\$]}
    dict set rule msg      "The 1st lsearch arg must be a variable, command or list"
    lappend RULES $rule

    dict set rule line_chk {llength[\s]+}
    # [\[\{\"\$] - is to check if we have a command, list or a variable as the first arg
    dict set rule rule     {llength[\s]+(\\\n)?[\s]*[\[\{\"\$]}
    dict set rule msg      "The 1st llength arg must be a variable, command or list"
    lappend RULES $rule
}


proc ::regex_chk::review_file {filepath} {
    set handle [open $filepath "r"]
    set rowno 0
    set lcmd [list]

    while {[gets $handle line] >= 0} {
        incr row

        if {[::regex_chk::is_line_to_skip $line]} {
            continue
        }

        if {[::regex_chk::is_complete $line]} {
            lappend lcmd $line
            set line [join $lcmd "\n"]
            set lcmd [list]
        } else {
            lappend lcmd $line
            continue
        }

        set result [::regex_chk::run_checks $line]

        if {[dict get $result status] == 1} {
            continue
        }

        ::rev::log WARN "---------------------------------"
        ::rev::log WARN "$filepath - Line:$row"
        ::rev::log WARN [dict get $result msg]
        ::rev::log WARN $line
        ::rev::log WARN ""
    }
    close $handle
}


proc ::regex_chk::is_line_to_skip {line} {
    if {[regexp {^\s*(#.*|proc.*)?$} $line]} {
        return 1
    }
    return 0
}


proc ::regex_chk::is_complete {line} {
    # Backslash at the end of a line suggests a split line command
    if {[regexp {\\[\s]*$} $line]} {
        return 0
    }

    if {[info complete $line]} {
        return 1
    }
    return 0
}


proc ::regex_chk::run_checks {line} {
    foreach rule $::regex_chk::RULES {
        set is_on_line [regexp [dict get $rule line_chk] $line]
        if {!$is_on_line} {
            continue
        }

        set is_valid [regexp [dict get $rule rule] $line]
        if {!$is_valid} {
            return [list status 0 msg [dict get $rule msg]]
        }
    }

    return [list status 1 msg ""]
}
