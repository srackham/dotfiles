# Projects on the local drive

03-May-2025: All projects apart from my Gleam experiments moved to the `~/projects/` directory on the server NFS share.

06-Nov-2024: The `$HOME/local/projects` directory contains projects that are developed on the local drive instead of server NFS drive. This is usually for performance reasons.

- Gleam projects are local because they fail to build on NFS drives (see https://github.com/gleam-lang/gleam/issues/2680#issuecomment-2451182120)
