# Projects on the local drive

06-Nov-2024

- The `$HOME/local/projects` directory contains projects that are developed on the local drive instead of server NFS drive. This is usually for performance reasons.

- A cron job mirrors directories in `$HOME/local/projects` to the `$HOME/share/projects` directory on the network NFS drive every 30 minutes. See `$HOME/bin/sync-local.bin` and `$HOME/nixos-configurations/nixos1-configuration.nix`.

- Gleam projects are local because they fail to build on NFS drives (see https://github.com/gleam-lang/gleam/issues/2680#issuecomment-2451182120)
