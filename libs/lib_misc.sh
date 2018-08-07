#!/bin/bash
#
# Misc. Utilities.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_MISC=1;

function is_array() {
    #############################################
    # Tells you if a variable is an array or not.
    #############################################
    local func=$(basename "${FUNCNAME[0]}")

    [[ $# -eq 1 ]] || { printf "Usage: %s variable_name\n" "${func}"; return 1; }

    declare -p $1 | grep -q '^declare \-a' && echo array || echo no array
}
    
