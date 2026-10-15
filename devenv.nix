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
    "newcomputermodern"
    "fontspec"
    "unicode-math"
    "lua-unicode-math"
  ];

  # Pin the experimental class so interface changes are tested deliberately.
  #
  # To bump: change the tag and version, then update the hash (Nix reports
  # the expected value on mismatch).
  ltx-talk-src = pkgs.fetchFromGitHub {
    owner = "josephwright";
    repo = "ltx-talk";
    tag = "v0.6.9";
    hash = "sha256-2mxx74m2VKbL8ncvL5F18JjEoVy/CHepfr4V3XN4vtI=";
  };

  # A minimal texlive-style package: the combined environment keys packages by
  # pname and keeps the first one it sees, so listing this ahead of the base
  # set below makes it win over the ltx-talk that scheme-medium pulls in.
  ltx-talk = {
    pname = "ltx-talk";
    version = "0.6.9";
    outputs = [ "tex" ];
    tex = pkgs.runCommand "ltx-talk-0.6.9-tex" { } ''
      mkdir -p work && cd work
      cp ${ltx-talk-src}/*.dtx ${ltx-talk-src}/*.ins .
      ${pkgs.texliveBasic}/bin/tex -interaction=batchmode ltx-talk.ins
      install -Dm444 ltx-talk.cls -t "$out/tex/latex/ltx-talk"
    '';
  };

  # nixpkgs still ships LaTeX 2025-11-01, but ltx-talk 0.6 requires the
  # 2026-06-01 kernel and matching tagging packages. Keep their checksums in
  # a separate manifest so the archived snapshot remains reproducible.
  latexPackages = builtins.fromJSON (builtins.readFile ./nix/latex-packages.json);
  latexOverrides = builtins.map (
    name:
    let
      package = latexPackages.${name};
      src = pkgs.fetchurl {
        url = "https://texlive.info/tlnet-archive/2026/10/11/tlnet/archive/${package.package}.r${toString package.revision}.tar.xz";
        inherit (package) sha512;
      };
    in
    {
      pname = name;
      version = toString package.revision;
      outputs = [ "tex" ];
      tlDeps = pkgs.texlive.pkgs.${name}.tlDeps or [ ];
      tex = pkgs.runCommand "${name}-${toString package.revision}-tex" { } ''
        mkdir -p "$out"
        tar -xf ${src} -C "$out" --exclude=tlpkg
      '';
    }
  ) (builtins.attrNames latexPackages);

  # Current l3kernel includes the backends. Suppress the old standalone
  # package so kpathsea cannot select a stale driver from another directory.
  l3backend = {
    pname = "l3backend";
    outputs = [ "tex" ];
    tex = pkgs.runCommand "l3backend-merged-tex" { } ''
      mkdir -p "$out"
    '';
  };

  texlive =
    (pkgs.texliveMedium.withPackages (
      ps:
      [
        ltx-talk
        l3backend
      ]
      ++ latexOverrides
      ++ builtins.map (name: ps.${name}) texlivePackages
    )).overrideAttrs
      {
        # Rebuild formats in this environment so they use the updated kernel.
        __combine = true;
      };

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
    pkgs.nodejs
    pkgs.wrangler
    pkgs.go-task
    pkgs.poppler-utils
  ];

  # https://devenv.sh/basics/
  enterShell = ''
    unset QUARTO_PANDOC
  '';

  # See full reference at https://devenv.sh/reference/options/
}
