#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2026 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: MIT

### description ################################################################

# Provide prepare_exec for GitLab runner.

### shellcheck #################################################################

# Nothing here.

### dependencies ###############################################################

SELF_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# shellcheck disable=SC1091 # dynamic include
source "$SELF_DIR/common.sh"

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function wait_for_ssh
{
    local ip=$1
    # shellcheck disable=SC2034 # unused index variable
    for i in $(seq 1 30); do
        if ssh -i "$RUNNER_SSH_KEY" -o ConnectTimeout=60 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$RUNNER_USER@$ip" "echo hello" >/dev/null 2>&1; then
            return 0
        fi
        sleep 2
    done
    return 1
}

function create_server {
    local password
    password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32)
    echo "creating server..."
    if tuca servers create \
            --name "$RUNNER_ID" \
            --snapshot glrwin \
            --flavorid 8x16 \
            --password "$password" \
            --wait > "$RUNNER_ID".json; then
        echo "server $RUNNER_ID is up"
        local ip
        ip=$(get_ip)
        if wait_for_ssh "$ip"; then
            echo "ssh access is available"
            touch ~/.ssh/known_hosts
            ssh-keygen -R "$ip"
            ssh-keyscan -t rsa "$ip" >> ~/.ssh/known_hosts
            return 0
        else
            echo "ssh access unavailable"
            delete_server
            return 1
        fi
    else
        echo "failed to create server"
        rm "$RUNNER_ID".json
        return 1
    fi
}

### main #######################################################################

if create_server; then
    exit 0
else
    exit 1
fi
