#
set ::xtn tcl

foreach {pkg ver file} {
    bal_char  1.0 bal_char
    regex_chk 1.0 regex_chk
    cmd_chk   1.0 cmd_chk
} {
    # correct file paths - used with a relative in auto_path (mainly tcltest)
    set path [file dirname [info script]]
    lappend path {*}${file}
    set filename [join [list [file join {*}$path] "." ${::xtn}] ""]
    set filename [file normalize $filename]

    package ifneeded $pkg $ver [list source $filename]
}
