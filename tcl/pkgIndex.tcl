#
set ::xtn tcl

foreach {pkg ver file} {
    rev       1.0 rev
    report    1.0 report
} {
    # correct file paths - used with a relative in auto_path (mainly tcltest)
    set path [file dirname [info script]]
    lappend path {*}${file}
    set filename [join [list [file join {*}$path] "." ${::xtn}] ""]
    set filename [file normalize $filename]

    package ifneeded $pkg $ver [list source $filename]
}
