#
package provide rev 1.0

package require log       1.0
package require path      1.0
package require regex_chk 1.0
package require bal_char  1.0

namespace eval ::rev {}

proc ::rev::main {dir inc_symlinks} {
    ::regex_chk::init

    set files [::path::get_tcl_files_paths $dir $inc_symlinks]

    foreach {dirname files} $files {
        foreach filepath $files {
            ::rev::review_file $filepath
        }
    }
}

proc ::rev::review_file {filepath} {
    set handle [open $filepath "r"]
    set data [read $handle]
    close $handle

    set report [regex_chk::review $filepath $data]

    set balanced_braces [::bal_char::is_brace_balanced $data]
    if {![dict get $balanced_braces status]} {
        set left  [dict get $balanced_braces left]
        set right [dict get $balanced_braces right]
        set report [::report::add_issue \
            $report \
            $filepath \
            ERROR \
            "" \
            "Unbalanced braces - no. of: left: $left, right: $right" \
            "" \
        ]
    }

    ::report::write $report
}
