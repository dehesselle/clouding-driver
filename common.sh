#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2026 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: MIT

### description ################################################################

# Provide common functions and variables.

### shellcheck #################################################################

# Nothing here.

### dependencies ###############################################################

# Nothing here.

### variables ##################################################################

RUNNER_ID="$CI_PROJECT_NAME-$CI_JOB_NAME_SLUG"
# shellcheck disable=SC2034 # used by the other scripts
RUNNER_USER="Administrator"
# shellcheck disable=SC2034 # used by the other scripts
RUNNER_SSH_KEY=foobar

### functions ##################################################################


function delete_server
{
    if [ -f "$RUNNER_ID.json" ]; then
        local name
        name=$(jq -r '.servers[0].name' "$RUNNER_ID.json")
        if tuca servers delete --name "$name"; then
            echo "deleting '$name'"
            rm "$RUNNER_ID".json
        else
            echo "failed to delete '$name', descending into chaos!"
            mv "$RUNNER_ID".json "$RUNNER_ID".json.delete
            return 1
        fi
    else
        echo "nothing to delete"
    fi
    return 0
}

function get_ip
{
    jq -r '.servers[0].publicIp' "$RUNNER_ID.json"
}

### main #######################################################################

# Nothing here.
