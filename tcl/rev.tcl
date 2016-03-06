#
package provide rev 1.0

package require log       1.0
package require path      1.0
package require regex_chk 1.0
package require bal_char  1.0

namespace eval ::rev {}

proc ::rev::main {dir} {
    ::regex_chk::init

    set files [::path::get_tcl_files_paths $dir]

    foreach {dirname files} $files {
        foreach filepath $files {
            ::rev::review_file $filepath
        }
    }
}

proc ::rev::review_file {filepath} {
    regex_chk::review_file $filepath
    ::report::write
    ::report::reset

    set handle [open $filepath "r"]
    set data [read $handle]
    close $handle

    set balanced_braces [::bal_char::is_brace_balanced $data]
    if {!$balanced_braces} {
        ::report::add_issue ERROR "" $filepath "Unballanced braces" ""
        ::report::write
        ::report::reset
    }
}
