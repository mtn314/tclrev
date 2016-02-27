#
set lvar [list a b c d e]

llength $lvar

llength [list a b c d e]

llength {a b c d}

llength \
    {a b c d}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Invalid

llength lvar
