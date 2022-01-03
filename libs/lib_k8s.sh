#!/bin/bash
#
# Utility functions related to kubernetes.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_FILES=1

function klistall() {
    # ===========================================================
    # Lists all k8s resources in provided namespace.
    # ===========================================================
    local func=$(basename "${FUNCNAME[0]}")

    if [[ $# -ne 1 ]]; then
        printf "Usage: %s namespace\n" "${func}"
        return 1
    fi

    local namespace=$1

    kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n ${namespace}
}

