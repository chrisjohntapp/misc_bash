#!/bin/bash
#
# Utility functions for working with docker.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_DOCKER=1

function docker_rm_all_containers() {
    docker rm $(docker ps -qa)
}

function docker_rm_all_containers_and_images() {
    docker kill $(docker ps -q) ; docker rm $(docker ps -a -q) && docker rmi $(docker image list -q)
}

function docker_rm_all_dangling_volumes() {
    docker volume rm $(docker volume ls -qf dangling=true)
}

function docker_show_volumes() {
    local func=$(basename "${FUNCNAME[0]}")

    if [[ $# -ne 1 ]]; then
        printf "Usage: %s container-name\n" "${func}"
        return 1
    fi

    docker inspect -f '{{ .Volumes }}' $1
}

