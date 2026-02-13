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
    echo "waiting for ssh ..."
    # shellcheck disable=SC2034 # unused index variable
    for i in $(seq 1 30); do
        if ssh -i "$WORKER_SSH_KEY" \
                -o ConnectTimeout=60 \
                -o StrictHostKeyChecking=no \
                -o UserKnownHostsFile=/dev/null \
                "$WORKER_USER@$ip" "echo hello" >/dev/null 2>&1; then
            echo "ssh is up"
            return 0
        fi
        sleep 2
    done
    return 1
}

function create_server {
    local password
    password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32)
    echo "creating server $WORKER_ID ..."
    if tuca servers create \
            --name "$WORKER_ID" \
            --snapshot "$WORKER_SNAPSHOT" \
            --flavorid "$WORKER_FLAVOR" \
            --password "$password" \
            --wait > "$WORKER_ID_FILE"; then
        echo "server created"
        local ip
        ip=$(get_ip)
        if wait_for_ssh "$ip"; then
            touch ~/.ssh/known_hosts
            ssh-keygen -R "$ip"
            ssh-keyscan -t rsa "$ip" >> ~/.ssh/known_hosts
            execute_custom_init
            return 0
        else
            echo "ssh access unavailable"
            delete_server
            return 1
        fi
    else
        echo "failed to create server"
        rm "$WORKER_ID_FILE"
        return 1
    fi
}

function execute_custom_init
{
    local file="$SELF_DIR/$WORKER_INIT"
    if [ -f "$file" ]; then
        echo "executing custom initialization ..."
        ssh -i "$WORKER_SSH_KEY" \
        -o ServerAliveInterval=60 \
        -o ServerAliveCountMax=60 \
        "$WORKER_USER@$(get_ip)" \
        "$WORKER_CMD" < "$file" || exit 1
        echo "initialization finished"
    fi
}

### main #######################################################################

if create_server; then
    exit 0
else
    exit 1
fi
