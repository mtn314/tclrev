#
set ::xtn tcl

foreach {pkg ver file} {
    args  1.0 args
    tlog  1.0 tlog
    path  1.0 path
} {
    # correct file paths - used with a relative in auto_path (mainly tcltest)
    set path [file dirname [info script]]
    lappend path {*}${file}
    set filename [join [list [file join {*}$path] "." ${::xtn}] ""]
    set filename [file normalize $filename]

    package ifneeded $pkg $ver [list source $filename]
}
