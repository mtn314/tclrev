#
package provide bal_char 1.0

namespace eval ::bal_char {}

#
# Checks if the given string has balanced braces
# returns: 1 - yes, 0 - no
proc ::bal_char::is_brace_balanced {string} {
    set counter 0

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
            } elseif {$char == "\}"} {
                incr counter -1
            }
        }
    }

    if {$counter == 0} {
        return 1
    } else {
        return 0
    }
}
