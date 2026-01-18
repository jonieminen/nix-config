
# Flakes tutorial by Juuso

In flake.nix, you have essentially a JSON structure which corresponds to Flake output schema defined here: https://nixos.wiki/wiki/Flakes

Flakes is a version-pinned definition of your Nix configuration.

To update *all* inputs, you can run `nix flake update`.
This is essentially like running `apt update`.

You can also update a single input with `nix flake update nixpkgs`.

## Shells

You can enter a development shell *of your flake* by running `nix develop` or with `direnv` installed on your system by running `direnv allow`.

## Checks

You can run various healt-checks on your flake with `nix flake check`.

## Packages

You can build flake-relative packages, such as your NixOS image with `nix build .#prose`

Here, `.#` means "this flake", followed by the name of the package.

This will results in a `results` folder which has your kernel (`bzImage`) and initrd `initrd.zst`.

You can boot this whole thing by running `sudo ./result/kexec-boot`.

## Iterating on your configuration

Your host is defined in `./nixosConfigurations/prose/default.nix`.

You can apply changes made to this file by running: `sudo nixos-rebuild test --flake .#`, supposing you are already on your `prose` host.

The `.#` will be automatically extended to your own hostname.

This should be the main way to iterate on your configuration.

## Configuration discovery

You can find programs available for NixOS from https://search.nixos.org/packages

You can find modules available for NixOS from https://search.nixos.org/options

You can find home-manager specific configuration from https://nix-community.github.io/home-manager/options.xhtml

