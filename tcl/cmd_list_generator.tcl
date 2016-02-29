#

# for given paths
#   add to auto_path
#   find and source all pkgIndex.tcl
#   run {{package names}}
#   require all packages
#   find all children namespaces to ::
#   run {{info commands}}
#   create a list of commands that can be used during checks
lappend ::auto_path [file normalize [file dirname [info script]]]

package require args 1.0

proc parse_args {} {
    dict set args_def "--paths" desc "Space separated paths to directories to scan for tcl commands"
    dict set args_def "--out"   desc "Path to an output file that will contain existing commands. If the file exists, it will be overwritten"

    return [::args::parse $args_def]
}

proc main {paths filepath} {
    lappend ::auto_path {*}$paths

    source_pkg_index_files $paths

    require_packages [package names]

    set lcmds [get_list_of_all_commands]

    write_list_to_file $filepath $lcmds
}

proc source_pkg_index_files {paths} {
    foreach dir $paths {
        set files [glob -nocomplain -directory $dir pkgIndex.tcl]
        foreach f $files {
            source $f
        }
    }
}

proc require_packages {pkgs} {
    foreach pkg $pkgs {
        puts "Requiring: $pkg"
        package require $pkg
    }
}

proc get_list_of_all_commands {} {
    set lcmds [list]
    lappend lcmds {*}[info commands "*"]

    foreach ns [namespace children "::"] {
        lappend lcmds {*}[info commands "${ns}::*"]
    }
    return $lcmds
}

proc write_list_to_file {filepath list_to_write} {
    set handle [open $filepath "w"]

    foreach item $list_to_write {
        puts $handle $item
    }

    close $handle
}

set args [parse_args]
main [dict get $args paths] [dict get $args out]
# package require Tk ends up with a graphical window if the exit below is not present
exit
