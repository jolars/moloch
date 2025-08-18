# Moloch <a href="https://ctan.org/pkg/moloch"><img src="https://github.com/jolars/moloch/raw/main/assets/moloch-logo.svg" align="right" width="140" /></a>

[![CTAN](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fctan.org%2Fjson%2F2.0%2Fpkg%2Fmoloch&query=%24.version.number&logo=latex&label=CTAN)](https://ctan.org/pkg/moloch)
[![Build-and-Test](https://github.com/jolars/moloch/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/jolars/moloch/actions/workflows/build-and-test.yml)

Moloch is a simple Beamer theme suitable for anyone to use. It is
a fork of the [Metropolis Theme](https://github.com/matze/mtheme).

The fork was created for the following reasons:

- To fix some outstanding issues that had not been addressed for a long time.
- To remove some of the more opinionated design choices, such as special handling of the Fira family of fonts.
- To strip away some features that added complexity to the code base without achieving valuable functionality for the majority of users, such as special code block designs and the pgfplots theme.

[Here's a blog post](https://jolars.co/blog/2024-05-30-moloch/) in which I introduce the theme and write in more detail about the changes with respect to Metropolis.
Also see the [demo](examples/demo/demo.pdf) for a quick introduction to the theme.

Do not expect this theme to be backwards compatible with the Metropolis theme.

![Screenshot](https://raw.githubusercontent.com/jolars/moloch/main/assets/screenshot.svg)

## Installation

Moloch is on [CTAN](https://ctan.org/pkg/moloch), so you can install it using your favorite LaTeX package manager. For example, with `tlmgr`:

```bash
tlmgr install moloch
```

You can also install the theme from source, in which case you need a working LaTeX installation with `l3build` installed. Then just follow these steps:

```bash
git clone https://github.com/jolars/moloch.git
cd moloch
l3build install
```

## Usage

The following code shows a minimal example of a Beamer presentation using
Moloch.

```latex
\documentclass{beamer}
\usetheme{moloch}
\title{A minimal example}
\date{\today}
\author{Johan Larsson}
\institute{Centre for Modern Beamer Themes}
\begin{document}
  \maketitle
  \section{First Section}
  \begin{frame}{First Frame}
    Hello, world!
  \end{frame}
\end{document}
```

## License

The theme itself is licensed under a [Creative Commons Attribution-ShareAlike
4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/). This
means that if you change the theme and re-distribute it, you _must_ retain the
copyright notice header and license it under the same CC-BY-SA license. This
does not affect the presentation that you create with the theme.

## Contributing

Contributions are welcome, but we are generally not interested in changes that can be easily added through the standard Beamer interface.

Also, when writing commit messages, please use the [conventional commits format](https://www.conventionalcommits.org/en/v1.0.0/).

## Versioning

The project uses [semantic versioning](https://semver.org).

## Acknowledgments

Almost all of **moloch** is a result of [Mathias Vogelgesang's](https://github.com/matze) hard work on the
**metropolis theme** (of which **moloch** is a fork).

Thanks to @samcarter for the logo!
