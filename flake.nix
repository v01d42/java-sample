{
  input = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts"
  };

  outputs = input @ {
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      system = ["aarch64-darwin" "x86_64-linux" "aarch64-linux"];

      perSystem = {
        system,
        pkgs,
        inputs',
        ...
      }:
      let
        jdk = pkgs.openjdk17_headless;

        maven = pkgs.maven.override {
          jdk_headless = jdk;
        }
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            jdk

            (pkgs.jdt-language-server.override {
              inherit jdk;
            })

            (pkgs.kotlin-language-server.override) {
              openjdk = jdk;
              inherit maven
            }
          ]
        }
      }
    }
}
