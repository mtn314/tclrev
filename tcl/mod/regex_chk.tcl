#
package provide regex_chk 1.0

package require report 1.0

namespace eval ::regex_chk {
    variable RULES
}

proc ::regex_chk::init {} {
    variable RULES
    catch {unset RULES}

    # Exclude stuff like variable names ending with the command's name
    set re_prefix     {(^|[\[\{\s\"])}
    # To allow for multi line matching
    set re_multiline  {(\\\n)?[\s]*}
    # To check if we have a command, list or a variable as the first arg
    # The possible leading \ is to deal with cases when the match is a string, like:
    #   set command "lsearch \$list a"
    set re_not_word   {\\{0,1}[\[\{\"\$]}

    set line_chk [format "%s%s" $re_prefix {expr[\s]+}]
    set rule     [format "%s%s%s" $line_chk $re_multiline {\{}]
    set msg      "expr's expression needs to be enclosed in {}"
    set level    WARN
    ::regex_chk::add_rule $line_chk $rule $msg $level

    foreach {cmd re_cmd_switch} {
        lsearch {((\-[a-z\-]+\s+)*|(\-index\s[0-9]+\s+)*|(\-start\s[0-9]+\s+)*)*}
        lsort   {((\-[a-z\-]+\s+)*|(\-index\s[0-9]+\s+)*|(\-command\s[^\s]+\s+)*)*}
    } {
        set line_chk [format "%s%s%s" $re_prefix $cmd {[\s]+}]
        set rule     [format "%s%s%s%s" $line_chk $re_cmd_switch $re_multiline $re_not_word]
        set msg      "The 1st $cmd arg must be a variable, command or list"
        set level    ERROR
        ::regex_chk::add_rule $line_chk $rule $msg $level
    }

    foreach cmd {
        llength
        lreverse
        lreplace
        lrange
        lindex
    } {
        set line_chk [format "%s%s%s" $re_prefix $cmd {[\s]+}]
        set rule     [format "%s%s%s" $line_chk $re_multiline $re_not_word]
        set msg      "The 1st $cmd arg must be a variable, command or list"
        set level    ERROR
        ::regex_chk::add_rule $line_chk $rule $msg $level
    }
}


proc ::regex_chk::add_rule {line_chk main_rule msg level} {
    variable RULES
    lappend RULES [list line_chk $line_chk rule $main_rule msg $msg level $level]
}


proc ::regex_chk::review {filepath data {report ""}} {
    set rowno 0
    set lcmd [list]

    foreach line [split $data "\n"] {
        incr rowno

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

        set report [::report::add_issue \
            $report \
            $filepath \
            [dict get $result level] \
            $rowno \
            [dict get $result msg] \
            $line \
        ]
    }
    return $report
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
        if {![::tlog::is_level_enabled [dict get $rule level]]} {
            continue
        }
        set is_on_line [regexp [dict get $rule line_chk] $line]
        if {!$is_on_line} {
            continue
        }

        set is_valid [regexp [dict get $rule rule] $line]
        if {!$is_valid} {
            return [list status 0 msg [dict get $rule msg] level [dict get $rule level]]
        }
    }

    return [list status 1 msg ""]
}
