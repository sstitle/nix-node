{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        bundle = import ./. { };
        imageName = "vite-nix-example";
        imageCmd = [ "node" "${bundle}/dist/index.html" ];
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            prefetch-npm-deps
            git
          ];
        };

        packages = {
          vite-nix-example = pkgs.buildNpmPackage {
            pname = "vite-nix-example";
            version = "0.0.1";
            src = ./.;
            npmDepsHash = "sha256-GdBAQ0EtjBAwjbvgU9PrweV5xnR+94NOhOAPXwWiC1I=";
            installPhase = ''
              runHook preInstall
              mkdir $out
              mv dist node_modules $out
              runHook postInstall
            '';
          };
        };
      });
}
