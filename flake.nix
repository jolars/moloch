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
        texlive = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-basic
            l3build
            beamer
            biblatex
            enumitem
            fileinfo
            hypdoc
            hyperref
            listings
            metalogo
            parskip
            pgf
            pgfopts
            setspace
            xurl
            microtype
            ;
        };
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
          ];
          # shellHook = ''
          #   export TEXMF="${texlive}/"
          # '';
        };
      }
    );
}
