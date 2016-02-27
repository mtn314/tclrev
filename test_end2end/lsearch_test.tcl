#
set lvar [list a b c d e]

lsearch $lvar a

lsearch [list a b c d e] a

lsearch {a b c d} a

lsearch \
    {a b c d} a

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Invalid

lsearch lvar a
