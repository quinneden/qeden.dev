{
  description = "qeden.dev";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    shibui.url = "github:ntk148v/shibui";
    shibui.flake = false;
  };

  outputs =
    {
      nixpkgs,
      shibui,
      self,
    }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      eachSystem = f: lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in
    {
      packages = eachSystem (pkgs: {
        default = pkgs.stdenv.mkDerivation {
          name = "qeden-dev";
          src = self;
          nativeBuildInputs = [ pkgs.hugo ];
          buildPhase = ''
            ln -sfT ${shibui} themes/shibui
            hugo build --gc --minify --noBuildLock
          '';
          installPhase = ''
            cp -r public $out
          '';
        };
      });

      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = [ pkgs.hugo ];
          shellHook = ''
            ln -sfT ${shibui} themes/shibui
          '';
        };
      });
    };
}
