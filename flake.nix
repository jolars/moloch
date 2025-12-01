{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        texlive = pkgs.texlive.combined.scheme-full;
        l3build-wrapped = pkgs.writeShellScriptBin "l3build-wrapped" ''
          # NOTE: the trailing slash in TEXMF is required
          TEXMF="${texlive}/" ${texlive}/bin/l3build "$@"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            texlive
            l3build-wrapped
            pkgs.quartoMinimal
            pkgs.go-task
          ];
          # shellHook = ''
          #   export TEXMF="${texlive}/"
          # '';
        };
      }
    );
}
