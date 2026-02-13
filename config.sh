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

# Nothing here.

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
$("$XDG_CONFIG_HOME"/gitlab-runner/job_env.sh)
}
EOF
