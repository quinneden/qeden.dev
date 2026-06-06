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
      apps = eachSystem (pkgs: {
        default = {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "hugo-build-qeden-dev";
              runtimeInputs = [ pkgs.hugo ];
              text = ''
                ln -sfT ${shibui} themes/shibui
                hugo build --gc --minify --noBuildLock
                ls "$HUGO_CACHEDIR" || echo "NO CACHE DIR"
              '';
            }
          );
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
