# GitLab custom executor for Clouding.io

clouding-driver is a custom executor for GitLab Runner to use [Clouding.io](https://clouding.io) servers as workers that run jobs. While it can be used for any OS that Clouding.io supports, it was created with Windows workers in mind (see variables in `common.sh`).

## Requirements

- a Linux/Unix environment for the manging node
  - gitlab-runner, bash, jq, GNU readlink, ssh client utilities
  - [tuca](https://pypi.org/project/tuca/) as interface to Clouding.io API
  - create `cloudingio.tkn` to hold your API token
- a snapshot of your worker node
  - user setup with ssh key authentication
  - gitlab-runner.exe
- See the following settings in `common.sh`:

  ```bash
  WORKER_CMD="powershell.exe -Command -"
  WORKER_FLAVOR="8x16"
  WORKER_SHELL="pwsh"
  WORKER_SNAPSHOT="glrwinwork"
  WORKER_SSH_KEY=~/.ssh/clouding_rsa
  WORKER_USER="Administrator"
  ```

## GitLab Runner `config.toml`

Example configuration for the runner managing the workers.

```toml
[[runners]]
  name = "Clouding.io"
  url = "https://gitlab.com"
  id = 0000
  token = "glrt-redacted"
  token_obtained_at = 2026-01-01T00:00:00Z
  token_expires_at = 0001-01-01T00:00:00Z
  executor = "custom"
  builds_dir = "build"
  cache_dir = "cache"
  request_concurrency = 3
  [runners.cache]
    MaxUploadedArchiveSize = 0
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]
  [runners.custom]
    config_exec = "/etc/gitlab-runner/clouding-driver/config.sh"
    prepare_exec = "/etc/gitlab-runner/clouding-driver/prepare.sh"
    run_exec = "/etc/gitlab-runner/clouding-driver/run.sh"
    cleanup_exec = "/etc/gitlab-runner/clouding-driver/cleanup.sh"
```

## License

[MIT](LICENSE)
