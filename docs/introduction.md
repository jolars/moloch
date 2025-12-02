# Getting Started

## Installing from CTAN

For most users, we recommend installing Moloch from
[CTAN](https://www.ctan.org). If you keep your TeX distribution up-to-date,
chances are good that Moloch is already installed. If it is not, you need to
update your packages. If your distribution is TeX Live (or MacTeX on OS X), the
following command updates all packages.

```bash
tlmgr update --all
```

If this results in an error, you may need to run it with administrative
privileges:

```bash
sudo tlmgr update --all
```

MacTeX on OS X also provides a graphical interface for `tlmgr` called TeX Live
Utility.

For any other distribution please refer to its documentation on how to update
your packages.

## Installing from Source

If you want to use the development version of Moloch, you can install it
manually. You only need a recent LaTeX distribution which includes **l3build**.
Then simply follow the steps below.

Download the source with a `git clone` of <https://github.com/jolars/moloch>

Install the package by running

```bash
l3build install
```

inside the downloaded directory.

## A Minimal Example

The following code shows a minimal example of a Beamer presentation using
Moloch.

```latex
\documentclass{beamer}
\usetheme{moloch}

\title{A Minimal Example}

\date{\today}
\author{Johan Larsson}
\institute{Some University}

\begin{document}
    \maketitle

    \section{First Section}

    \begin{frame}
        \frametitle{First Frame}

        Hello, world!

    \end{frame}
\end{document}
```

## Dependencies

Moloch depends on the `beamer` class and the following standard packages:

- [tikz](https://ctan.org/pkg/pgf)
- [pgfopts](https://ctan.org/pkg/pgfopts)
- [etoolbox](https://ctan.org/pkg/etoolbox)
- [calc](https://ctan.org/pkg/calc)

## Pandoc

To use this theme with [Pandoc](http://johnmacfarlane.net/pandoc/)-based
presentations, you can run the following command in your terminal:

```bash
pandoc -t beamer -V theme:moloch -o output.pdf input.md
```
