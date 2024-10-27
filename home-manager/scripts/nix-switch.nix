{ pkgs, ... }:
let
  symlink = pkgs.writeShellScript "symlink" ''
    if [[ "$1" == "-r" ]]; then
      rm -rf "$HOME/.config/nvim"
      rm -rf "$HOME/.config/ags"
    fi

    if [[ "$1" == "-a" ]]; then
      rm -rf "$HOME/.config/nvim"
      rm -rf "$HOME/.config/ags"

      ln -s "$HOME/Projects/dotfiles/nvim" "$HOME/.config/nvim"
      ln -s "$HOME/Projects/dotfiles/ags" "$HOME/.config/ags"
    fi
  '';
  nix-switch = pkgs.writeShellScriptBin "nix-switch" ''
    ${symlink} -r
    sudo nixos-rebuild switch --flake . --impure $@
    ${symlink} -a
  '';
  nix-boot = pkgs.writeShellScriptBin "nix-boot" ''
    ${symlink} -r
    sudo nixos-rebuild boot --flake . --impure $@
    ${symlink} -a
  '';
  nix-test = pkgs.writeShellScriptBin "nix-test" ''
    ${symlink} -r
    sudo nixos-rebuild test --flake . --impure $@
    ${symlink} -a
  '';
in
{
  home.packages = [
    nix-switch
    nix-boot
    nix-test
  ];
}
