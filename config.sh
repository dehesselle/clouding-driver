#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2026 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: MIT

### description ################################################################

# Provide config_exec for GitLab runner.

### shellcheck #################################################################

# Nothing here.

### dependencies ###############################################################

SELF_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
# shellcheck disable=SC1091 # dynamic include
source "$SELF_DIR/common.sh"

### variables ##################################################################

# Nothing here.

### functions ##################################################################

# Nothing here.

### main #######################################################################

cat << EOF
{
  "driver": {
    "name": "Clouding",
    "version": "v0.1.0"
  },
  "job_env": {
    "CLOUDINGIO_API_TOKEN": "secret"
  },
  "shell": "$WORKER_SHELL"
}
EOF
