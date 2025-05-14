#
# Nix Single-user Home Manager configuration.
#

{ config, pkgs, ... }:

{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    bat
    chezmoi
    delve
    deno
    eza
    fd
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
    jq
    lazygit
    lua
    marksman
    neovim
    nil
    nixfmt-rfc-style
    nodejs
    npm-check-updates
    prettierd
    ripgrep
    sd
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
