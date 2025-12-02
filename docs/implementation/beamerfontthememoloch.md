---
title: "Font Theme"
---

::: {.callout-note}

**Source file:** [`src/beamerfontthememoloch.dtx`](https://github.com/jolars/moloch/blob/main/src/beamerfontthememoloch.dtx)

:::

## Moloch font theme

The Moloch font theme defines the fonts used throughout the
presentation.

## Package dependencies

``` latex
\RequirePackage{etoolbox}
\RequirePackage{pgfopts}
```

## General font definitions

``` latex
\setbeamerfont{title}{size=\Large, series=\bfseries}
\setbeamerfont{author}{size=\small}
\setbeamerfont{date}{size=\small}
\setbeamerfont{section title}{size=\Large, series=\bfseries}
\setbeamerfont{block title}{size=\normalsize, series=\bfseries}
\setbeamerfont{block title alerted}{size=\normalsize, series=\bfseries}
\setbeamerfont*{subtitle}{size=\large}
\setbeamerfont{frametitle}{size=\large, series=\bfseries}
\setbeamerfont{framesubtitle}{size=\small}
\setbeamerfont{caption}{size=\small}
\setbeamerfont{caption name}{series=\bfseries}
\setbeamerfont{description item}{series=\bfseries}
\setbeamerfont{standout}{size=\Large, series=\bfseries}
```

## Title format options

### `titleformat title`

Controls the format of the title.

``` latex
\pgfkeys{
  /moloch/font/titleformat title/.cd,
  .is choice,
  regular/.code={%
      \let\moloch@titleformat\@empty%
      \setbeamerfont{title}{shape=\normalfont}%
    },
  smallcaps/.code={%
      \let\moloch@titleformat\@empty%
      \setbeamerfont{title}{shape=\scshape}%
    },
  allsmallcaps/.code={%
      \let\moloch@titleformat\lowercase%
      \setbeamerfont{title}{shape=\scshape}%
      \PackageNote{beamerthememoloch}{%
        Be aware that titleformat title=allsmallcaps can
        lead to problems}
    },
  allcaps/.code={%
      \let\moloch@titleformat\uppercase%
      \setbeamerfont{title}{shape=\normalfont}
      \PackageNote{beamerthememoloch}{%
        Be aware that titleformat title=allcaps can lead to problems%
      }
    },
}
```

### `titleformat subtitle`

Control the format of the subtitle.

``` latex
\pgfkeys{
  /moloch/font/titleformat subtitle/.cd,
  .is choice,
  regular/.code={%
      \let\moloch@subtitleformat\@empty%
      \setbeamerfont{subtitle}{shape=\normalfont}%
    },
  smallcaps/.code={%
      \let\moloch@subtitleformat\@empty%
      \setbeamerfont{subtitle}{shape=\scshape}%
    },
  allsmallcaps/.code={%
      \let\moloch@subtitleformat\MakeLowercase%
      \setbeamerfont{subtitle}{shape=\scshape}%
      \PackageNote{beamerthememoloch}{%
        Be aware that titleformat subtitle=allsmallcaps
        can lead to problems}
    },
  allcaps/.code={%
      \let\moloch@subtitleformat\MakeUppercase%
      \setbeamerfont{subtitle}{shape=\normalfont}%
      \PackageNote{beamerthememoloch}{%
        Be aware that titleformat subtitle=allcaps can
        lead to problems}
    },
}
```

### `titleformat section`

Controls the format of the section title.

``` latex
\pgfkeys{
  /moloch/font/titleformat section/.cd,
  .is choice,
  regular/.code={%
      \let\moloch@sectiontitleformat\@empty%
      \setbeamerfont{section title}{shape=\normalfont}%
    },
  smallcaps/.code={%
      \let\moloch@sectiontitleformat\@empty%
      \setbeamerfont{section title}{shape=\scshape}%
    },
  allsmallcaps/.code={%
      \let\moloch@sectiontitleformat\MakeLowercase%
      \setbeamerfont{section title}{shape=\scshape}%
      \PackageNote{beamerthememoloch}{%
        Be aware that titleformat section=allsmallcaps
        can lead to problems}
    },
  allcaps/.code={%
      \let\moloch@sectiontitleformat\MakeUppercase%
      \setbeamerfont{section title}{shape=\normalfont}%
      \PackageNote{beamerthememoloch}{%
        Be aware that titleformat section=allcaps
        can lead to problems}
    },
}
```

### `frametitleformat`

Control the format of the frame title.

``` latex
\pgfkeys{
  /moloch/font/titleformat frame/.cd,
  .is choice,
  regular/.code={%
      \let\moloch@frametitleformat\@empty%
      \setbeamerfont{frametitle}{shape=\normalfont}%
    },
  smallcaps/.code={%
      \let\moloch@frametitleformat\@empty%
      \setbeamerfont{frametitle}{shape=\scshape}%
    },
  allsmallcaps/.code={%
      \let\moloch@frametitleformat\MakeLowercase%
      \setbeamerfont{frametitle}{shape=\scshape}%
      \PackageNote{beamerthememoloch}{%
        Be aware that titleformat frame=allsmallcaps
        can lead to problems}
    },
  allcaps/.code={%
      \let\moloch@frametitleformat\MakeUppercase%
      \setbeamerfont{frametitle}{shape=\normalfont}
      \PackageNote{beamerthememoloch}{%
        Be aware that titleformat frame=allcaps can lead to problems%
      }
    },
}
```

### `titleformat aliases`

Allows `titleformat title` et al. to be used in the `\usetheme`
declaration, where LaTeX automatically removes all spaces.

``` latex
\pgfkeys{
  /moloch/font/.cd,
  titleformattitle/.code=\pgfkeysalso{titleformat title=#1},
  titleformatsubtitle/.code=\pgfkeysalso{titleformat subtitle=#1},
  titleformatsection/.code=\pgfkeysalso{titleformat section=#1},
  titleformatframe/.code=\pgfkeysalso{titleformat frame=#1},
}
```

### `\moloch@font@setdefaults`

Sets default values for font theme options.

``` latex
\newcommand{\moloch@font@setdefaults}{
  \pgfkeys{/moloch/font/.cd,
    titleformat title=regular,
    titleformat subtitle=regular,
    titleformat section=regular,
    titleformat frame=regular,
  }
}
```

We first define hooks to change the case format of the titles.

``` latex
\def\moloch@titleformat#1{#1}
\def\moloch@subtitleformat#1{#1}
\def\moloch@sectiontitleformat#1{#1}
\def\moloch@frametitleformat#1{#1}
```

To make the uppercase and lowercase macros work in the title, subtitle,
etc., we have to patch the appropriate `beamer` commands that set their
values. This solution was suggested by Enrico Gregorio in an answer to
[this StackExchange
question](http://tex.stackexchange.com/questions/112526/).

## Process package options

``` latex
\moloch@font@setdefaults
\ProcessPgfPackageOptions{/moloch/font}
```
