#
# Nix Single-user Home Manager configuration.
#

{ config, pkgs, ... }:

{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    bat
    btop
    chezmoi
    delve
    deno
    dig
    eza
    fastfetch
    fd
    ffmpeg
    fio
    fzf
    gcc
    gh
    git
    gnumake
    gnupg
    go
    golangci-lint
    golangci-lint-langserver
    gopls
    gotests
    gotools
    harper
    htop
    iotop
    iperf
    jq
    lazygit
    lsof
    lua
    marksman
    neovim
    nethogs
    nil
    nixd
    nixfmt-rfc-style
    ntfs3g
    ollama
    parted
    pass
    prettierd
    rclone
    ripgrep
    sd
    shellcheck
    smartmontools
    tesseract
    tmux
    tree
    busybox
    unzip
    xclip
    zoxide
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
