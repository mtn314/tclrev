#
package provide report 1.0

package require tlog 1.0

namespace eval ::report {}

proc ::report::add_issue {report filepath level line_no msg snippet} {
    set issue [list \
        level    $level\
        line_no  $line_no\
        msg      $msg\
        snippet  $snippet\
    ]

    if {[dict exists $report $filepath]} {
        set issues [dict get $report $filepath]
        lappend issues $issue
        dict set report $filepath $issues
    } else {
        dict set report $filepath [list $issue]
    }

    return $report
}

proc ::report::write {report} {
    foreach {filepath issues} $report {
        ::tlog::error [string repeat "=" 80]
        ::tlog::error [format "File : %s" $filepath]

        foreach issue $issues {
            switch [dict get $issue level] {
                WARN {
                    set logproc "::tlog::warn"
                }
                INFO {
                    set logproc "::tlog::info"
                }
                ERROR -
                default {
                    set logproc "::tlog::error"
                }
            }

            $logproc [string repeat "-" 20]
            $logproc [format "Line :%s" [dict get $issue line_no]]
            $logproc [format "Issue: %s" [dict get $issue msg]]
            $logproc [dict get $issue snippet]
            $logproc ""
        }
    }
}
