#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2026 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: MIT

### description ################################################################

# Provide run_exec for GitLab runner.

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

ssh -i "$SELF_DIR/$RUNNER_SSH_KEY" \
  -o ServerAliveInterval=60 \
  -o ServerAliveCountMax=60 \
  "$RUNNER_USER@$(get_ip)" \
  "powershell.exe -Command -" < "${1}" || exit 1
