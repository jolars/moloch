{ pkgs, ... }:

let
  # Single source of truth for the TeX environment: put on PATH below and
  # reused by the l3build wrapper. We build the combined set here rather than
  # via languages.texlive, because that option only accepts package *names*
  # and we need to inject a custom-built package (ltx-talk, see below).
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

    # Loaded by ltx-talk. The nixpkgs texlive package for the class does not
    # pull these in, so they have to be requested explicitly. fontspec,
    # unicode-math and lua-unicode-math are only used on the LuaTeX/XeTeX
    # paths, but ltx-talk documents are commonly built with lualatex.
    "tagpdf"
    "sansmathfonts"
    "relsize"
    "mathtools"
    "lm" # provides lmodern.sty
    "fontspec"
    "unicode-math"
    "lua-unicode-math"
  ];

  # ltx-talk is pinned instead of taken from nixpkgs. nixpkgs tracks the TeX
  # Live 2025 final snapshot (2026-03-01, the day TeX Live 2026 branched),
  # which carries ltx-talk 0.4.6, whereas a current TeX Live install has
  # 0.5.2. The class is a 0.x release with a moving interface, and test
  # output (.tlg) is sensitive to it, so pin the version and bump on purpose.
  #
  # To bump: change the tag and version, then update the hash (Nix reports
  # the expected value on mismatch).
  ltx-talk-src = pkgs.fetchFromGitHub {
    owner = "josephwright";
    repo = "ltx-talk";
    tag = "v0.5.2";
    hash = "sha256-dJpTv67aeVuPOEZyr7zErUPVSkuuds1AI9x2VkZ7WA0=";
  };

  # A minimal texlive-style package: the combined environment keys packages by
  # pname and keeps the first one it sees, so listing this ahead of the base
  # set below makes it win over the ltx-talk that scheme-medium pulls in.
  ltx-talk = {
    pname = "ltx-talk";
    version = "0.5.2";
    outputs = [ "tex" ];
    tex = pkgs.runCommand "ltx-talk-0.5.2-tex" { } ''
      mkdir -p work && cd work
      cp ${ltx-talk-src}/*.dtx ${ltx-talk-src}/*.ins .
      ${pkgs.texliveBasic}/bin/tex -interaction=batchmode ltx-talk.ins
      install -Dm444 ltx-talk.cls -t "$out/tex/latex/ltx-talk"
    '';
  };

  texlive = pkgs.texliveMedium.withPackages (
    ps: [ ltx-talk ] ++ builtins.map (name: ps.${name}) texlivePackages
  );

  l3build-wrapped = pkgs.writeShellScriptBin "l3build-wrapped" ''
    # NOTE: the trailing slash in TEXMF is required
    TEXMF="${texlive}/" ${texlive}/bin/l3build "$@"
  '';
in
{
  # https://devenv.sh/packages/
  packages = [
    pkgs.bashInteractive
    texlive
    pkgs.texlab # languages.texlive used to supply this
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
