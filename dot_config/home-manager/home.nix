#
# Nix Single-user Home Manager configuration.
#

{ config, pkgs, ... }:

{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    bat
    chezmoi
    delve
    deno
    dig
    eza
    fd
    fio
    fzf
    gcc
    gh
    git
    gnumake
    go
    golangci-lint
    golangci-lint-langserver
    gopls
    gotests
    gotools
    htop
    iotop
    jq
    jujutsu
    lazygit
    lua
    marksman
    neovim
    nethogs
    nil
    nixfmt-rfc-style
    nodejs
    npm-check-updates
    prettierd
    rclone
    ripgrep
    sd
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
