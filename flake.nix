{
  description = "A development shell with Node.js and Bun, with Docker support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs
            pkgs.bun
            pkgs.docker
          ];
        };

        packages = {
          run-dev-container = pkgs.writeShellScriptBin "run-dev-container" ''
            #!/bin/sh
            set -e
            docker build -t myapp-dev -f Dockerfile.dev .
            docker run --rm -p 5173:5173 myapp-dev
          '';

          run-release-container = pkgs.writeShellScriptBin "run-release-container" ''
            #!/bin/sh
            set -e
            docker build -t myapp-release -f Dockerfile.prod .
            docker run --rm -p 80:80 myapp-release
          '';
        };
      });
}
