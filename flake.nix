{
  description = "qeden.dev";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, self }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      eachSystem = f: lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in
    {
      # packages = eachSystem (pkgs: {
      #   default = pkgs.runCommand "qeden.dev" { nativeBuildInputs = [ pkgs.hugo ]; } ''
      #     hugo build --destination $out --gc --minify --noBuildLock --source ${self}
      #   '';
      # });

      apps = eachSystem (pkgs: {
        default = {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "hugo-build-qeden-dev";
              runtimeInputs = [ pkgs.hugo ];
              text = ''
                echo "baseURL: $HUGO_BASEURL"
                echo "cacheDir: $HUGO_CACHEDIR"
                hugo build --gc --minify --noBuildLock
                ls "$HUGO_CACHEDIR" || echo "NO CACHE DIR"
              '';
            }
          );
        };
      });
    };
}
