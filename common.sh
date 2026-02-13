#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2026 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: MIT

### description ################################################################

# Provide common functions and variables.

### shellcheck #################################################################

# shellcheck disable=SC2034 # variables are used by scripts sourcing this one

### dependencies ###############################################################

# Nothing here.

### variables ##################################################################

WORKER_CMD="powershell.exe -Command -"
WORKER_INIT=worker_init.ps1
WORKER_FLAVOR="8x16"
WORKER_ID="$CUSTOM_ENV_CI_PROJECT_NAME-$CUSTOM_ENV_CI_JOB_NAME_SLUG-$CUSTOM_ENV_CI_PIPELINE_IID"
WORKER_SHELL="pwsh"
WORKER_SNAPSHOT="glrwinwork"
WORKER_SSH_KEY=~/.ssh/clouding_rsa
WORKER_USER="Administrator"

### functions ##################################################################


function delete_server
{
    if [ -f "$WORKER_ID.json" ]; then
        local name
        name=$(jq -r '.servers[0].name' "$WORKER_ID.json")
        if tuca servers delete --name "$name"; then
            echo "deleting '$name'"
            rm "$WORKER_ID".json
        else
            echo "failed to delete '$name', descending into chaos!"
            mv "$WORKER_ID".json "$WORKER_ID".json.delete
            return 1
        fi
    else
        echo "nothing to delete"
    fi
    return 0
}

function get_ip
{
    jq -r '.servers[0].publicIp' "$WORKER_ID.json"
}

### main #######################################################################

# Nothing here.
