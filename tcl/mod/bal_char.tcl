#
package provide bal_char 1.0

namespace eval ::bal_char {}

#
# Checks if the given string has balanced braces
# returns:
#   true : {status 1 left <int> right <int>}
#   false: {status 0 left <int> right <int>}
proc ::bal_char::is_brace_balanced {string} {
    set counter 0
    set left_brace_ctr 0
    set right_brace_ctr 0

    foreach line [split $string "\n"] {
        if {[regexp {^\s*#} $line]} {
            continue
        }

        set skip_next_char 0
        foreach char [split $line ""] {
            # if a backslash, then ignore the next char, but only if the previous
            # wasn't a backslash
            if {$char == "\\" && $skip_next_char == 0} {
                set skip_next_char 1
                continue
            }
            if {$skip_next_char == 1} {
                set skip_next_char 0
                continue
            }

            if {$char == "\{"} {
                incr counter
                incr left_brace_ctr
            } elseif {$char == "\}"} {
                incr counter -1
                incr right_brace_ctr
            }
        }
    }

    if {$counter == 0} {
        return [list status 1 left $left_brace_ctr right $right_brace_ctr]
    } else {
        return [list status 0 left $left_brace_ctr right $right_brace_ctr]
    }
}
