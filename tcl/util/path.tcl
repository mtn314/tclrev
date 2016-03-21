#
package provide path 1.0

namespace eval ::path {}

#
# Returns paths to all TCL files in all subdirectories in
# args:
#   dir          - directory to traverse
#   inc_symlinks - scan symlinked directories as well
# return:
#   {dir1 {filepath1 filepath2} dir2 {filepath3 filepath4}}
proc ::path::get_tcl_files_paths {dir inc_symlinks} {

    if {![file isdirectory $dir]} {
        error "The input directory does not exist: $dir"
    }

    set ldirs [::path::get_recursive_dirs $dir $inc_symlinks]

    set lfiles [list]

    foreach dir $ldirs {
        lappend lfiles $dir [glob -nocomplain -directory $dir *.tcl]
    }

    return $lfiles
}

#
# Returns list of subdirectories in a directory
# args:
#   dir          - directory to traverse
#   inc_symlinks - scan symlinked directories as well
# return:
#   {dir1 dir2 dir3}
proc ::path::get_recursive_dirs {dir inc_symlinks} {
    set ldirs $dir

    foreach subdir [glob -nocomplain -type d [file join $dir *]] {
        if {$inc_symlinks == 0 && [file type $subdir] == "link"} {
            ::tlog::info "Skipping symlink: $subdir"
            return $ldirs
        }

        lappend ldirs {*}[::path::get_recursive_dirs $subdir $inc_symlinks]
    }
    return $ldirs
}
