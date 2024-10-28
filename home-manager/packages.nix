{ pkgs, inputs, ... }:
{
  imports = [
    ./modules/packages.nix
    ./scripts/blocks.nix
    ./scripts/vault.nix
  ];

  packages = with pkgs; {
    linux = [
      (mpv.override { scripts = [ mpvScripts.mpris ]; })
      # figma-linux
      # gnome-secrets
      # spotify
      # wine-staging
      # yabridge
      # yabridgectl
      asahi-bless
      fragments
      inputs.nix-shell-scripts.packages.aarch64-linux.default
      nh
      nodejs
      vagrant
    ];
    cli = [
      bat
      eza
      fd
      fzf
      gh
      git-crypt
      git-lfs
      glow
      gnumake
      gnupg
      jq
      lazydocker
      lazygit
      nixfmt-rfc-style
      pure-prompt
      python3
      rclone
      ripgrep
      zoxide
    ];
  };
}
