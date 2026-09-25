{
  description = "a desktop selection box for Wayland compositors";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      release = builtins.fromJSON (builtins.readFile ./release.json);
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: rec {
        selector = pkgs.stdenv.mkDerivation {
          pname = "selector";
          inherit (release) version;

          src = pkgs.fetchurl {
            inherit (release.${pkgs.stdenv.hostPlatform.system}) url hash;
          };
          sourceRoot = ".";

          nativeBuildInputs = [ pkgs.autoPatchelfHook ];
          buildInputs = [ pkgs.stdenv.cc.cc.lib ];

          installPhase = ''
            runHook preInstall
            install -Dm755 selector $out/bin/selector
            runHook postInstall
          '';

          meta = {
            description = "A desktop selection box for Wayland";
            homepage = "https://github.com/boatette/selector-flake";
            license = pkgs.lib.licenses.mit;
            mainProgram = "selector";
            platforms = systems;
            sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
          };
        };

        default = selector;
      });

      homeModules = rec {
        selector = import ./nix/home-manager.nix self;
        default = selector;
      };

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
    };
}
