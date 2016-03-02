#
package provide report 1.0

package require log 1.0

namespace eval ::report {
    variable ISSUES

    set ISSUES [list]
}

proc ::report::add_issue {level line_no filepath msg snippet} {
    variable ISSUES

    set issue [list \
        level    $level\
        line_no  $line_no\
        filepath $filepath\
        msg      $msg\
        snippet  $snippet\
    ]

    lappend ISSUES $issue
}

proc ::report::write {} {
    variable ISSUES

    foreach issue $ISSUES {
        switch [dict get $issue level] {
            WARN {
                set logproc "::log::warn"
            }
            INFO {
                set logproc "::log::info"
            }
            ERROR -
            default {
                set logproc "::log::error"
            }
        }

        $logproc "---------------------------------"
        $logproc [format "%s:%s" [dict get $issue filepath] [dict get $issue line_no]]
        $logproc [dict get $issue msg]
        $logproc [dict get $issue snippet]
        $logproc ""
    }
}

proc ::report::reset {} {
    variable ISSUES

    set ISSUES [list]
}
