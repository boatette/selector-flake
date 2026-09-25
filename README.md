# selector-flake

Nix flake for [selector](https://github.com/boatette/selector), a desktop selection box for Wayland compositors.

The selector source is not public. This repository only carries the flake and prebuilt release binaries for `x86_64-linux` and `aarch64-linux`. `release.json` and `nix/home-manager.nix` are written by the release workflow of the source repository, so changes made here by hand will be overwritten.

## Usage

```nix
{
  inputs.selector = {
    url = "github:boatette/selector-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Run it once:

```sh
nix run github:boatette/selector-flake
```

Or use the home-manager module:

```nix
{ inputs, ... }:
{
  imports = [ inputs.selector.homeModules.selector ];

  programs.selector.enable = true;
}
```

The module's options are documented in `nix/home-manager.nix`.

## License

MIT
