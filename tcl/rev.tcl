#
package provide rev 1.0

package require log       1.0
package require regex_chk 1.0

namespace eval ::rev {}

proc ::rev::main {dir} {
    ::regex_chk::init

    set files [::rev::get_tcl_files_paths $dir]

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
}


# args:
#   dir - directory to traverse
# return:
#   {dir1 {filepath1 filepath2} dir2 {filepath3 filepath4}}
proc ::rev::get_tcl_files_paths {dir} {

    if {![file isdirectory $dir]} {
        ::log::error "The input directory does not exist: $dir"
        return 0
    }

    set ldirs [::rev::get_recursive_dirs $dir]

    set lfiles [list]

    foreach dir $ldirs {
        lappend lfiles $dir [glob -nocomplain -directory $dir *.tcl]
    }

    return $lfiles
}

proc ::rev::get_recursive_dirs {dir} {
    set ldirs $dir
    foreach subdir [glob -nocomplain -type d [file join $dir *]] {
        lappend ldirs {*}[::rev::get_recursive_dirs $subdir]
    }
    return $ldirs
}
