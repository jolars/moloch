{ pkgs, ... }:

let
  # Single source of truth: fed to languages.texlive below, and reused to
  # rebuild the same combined set for the l3build wrapper (devenv doesn't
  # expose the combined texlive derivation, but Nix dedupes the build).
  texlivePackages = [
    "scheme-basic"
    "l3build"
    "beamer"
    "biblatex"
    "enumitem"
    "fileinfo"
    "hypdoc"
    "hyperref"
    "listings"
    "metalogo"
    "parskip"
    "pgf"
    "pgfopts"
    "setspace"
    "xurl"
    "microtype"
    "koma-script"
    "booktabs"
    "mdwtools"
    "caption"
    "float"
    "fancyvrb"
    "tcolorbox"
    "tikzfill"
    "pdfcol"
    "fontawesome5"
  ];

  texlive = pkgs.texliveMedium.withPackages (ps: builtins.map (name: ps.${name}) texlivePackages);

  l3build-wrapped = pkgs.writeShellScriptBin "l3build-wrapped" ''
    # NOTE: the trailing slash in TEXMF is required
    TEXMF="${texlive}/" ${texlive}/bin/l3build "$@"
  '';
in
{
  # https://devenv.sh/languages/texlive/
  languages.texlive = {
    enable = true;
    base = pkgs.texliveMedium;
    packages = texlivePackages;
  };

  # https://devenv.sh/packages/
  packages = [
    pkgs.bashInteractive
    l3build-wrapped
    pkgs.quarto
    pkgs.go-task
    pkgs.poppler-utils
  ];

  # https://devenv.sh/basics/
  enterShell = ''
    unset QUARTO_PANDOC
  '';

  # See full reference at https://devenv.sh/reference/options/
}
