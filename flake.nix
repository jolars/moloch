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
        texlive = pkgs.texliveMedium.withPackages (
          ps: with ps; [
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
            koma-script
            booktabs
            mdwtools
            caption
            float
            fancyvrb
            tcolorbox
            tikzfill
            pdfcol
            fontawesome5
          ]
        );
        l3build-wrapped = pkgs.writeShellScriptBin "l3build-wrapped" ''
          # NOTE: the trailing slash in TEXMF is required
          TEXMF="${texlive}/" ${texlive}/bin/l3build "$@"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.bashInteractive
            texlive
            l3build-wrapped
            pkgs.quartoMinimal
            pkgs.go-task
            pkgs.poppler_utils
          ];
        };
      }
    );
}
