#!/bin/bash
#
# Utilities to work with Ansible.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_ANSIBLE=1;

function ansible_setup_project() {
    ############################################
    # Setup new project based on my preferences.
    ############################################
    local func=$(basename "${FUNCNAME[0]}")

    [[ $# -ge 2 ]] || { printf "Usage: %s project_name env [env]+\n" "${func}"; return 1; }

    local project_name=$1; shift
    local repo=$(which repo) || { printf "repo not found\n"; return 1; }
    local start_dir="${PWD}"

    for env in $@; do
        mkdir -p ./${project_name}/${env}
        cd ./${project_name}/${env} || { printf "Could not cd to ${env}\n"; return 1; }
        $repo init -u https://github.com/chrisjohntapp/ansible-default-manifest.git -b ${env}
        $repo sync --no-clone-bundle
        cd "${start_dir}" || { printf "Could not cd to ${start_dir}\n"; return 1; }
    done
}
    
