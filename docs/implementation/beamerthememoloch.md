---
title: "Main Theme"
---

::: {.callout-note}

**Source file:** [`src/beamerthememoloch.dtx`](https://github.com/jolars/moloch/blob/main/src/beamerthememoloch.dtx)

:::

## Moloch Parent Theme

The primary job of this package is to load the component sub-packages of
the Moloch theme and route the theme options accordingly. It also
provides some custom commands and environments for the user.

## Package Dependencies

``` latex
\RequirePackage{pgfopts}
```

## Options

Most options are passed off to the component sub-packages.

``` latex
\pgfkeys{/moloch/.cd,
  .search also={
      /moloch/inner,
      /moloch/outer,
      /moloch/color,
      /moloch/font,
    }
}
```

Route color theme options to the new color system.

``` latex
\pgfkeys{/moloch/.cd,
  colortheme/.code=\pgfkeysalso{/moloch/colors/theme=#1},
  colorthemevariant/.code=\pgfkeysalso{/moloch/colors/variant=#1},
  colortheme variant/.code=\pgfkeysalso{/moloch/colors/variant=#1},
}
```

### `titleformat plain`

Controls the formatting of the text on standout "plain" frames.

``` latex
\pgfkeys{
  /moloch/titleformat plain/.cd,
  .is choice,
  regular/.code={%
      \let\moloch@plaintitleformat\@empty%
      \setbeamerfont{standout}{shape=\normalfont}%
    },
  smallcaps/.code={%
      \let\moloch@plaintitleformat\@empty%
      \setbeamerfont{standout}{shape=\scshape}%
    },
  allsmallcaps/.code={%
      \let\moloch@plaintitleformat\MakeLowercase%
      \setbeamerfont{standout}{shape=\scshape}%
    },
  allcaps/.code={%
      \let\moloch@plaintitleformat\MakeUppercase%
      \setbeamerfont{standout}{shape=\normalfont}%
    },
}
```

### `titleformat`

Sets a standard format for titles, subtitles, section titles, frame
titles, and the text on standout "plain" frames.

``` latex
\pgfkeys{
  /moloch/titleformat/.code=\pgfkeysalso{
    font/titleformat title=#1,
    font/titleformat subtitle=#1,
    font/titleformat section=#1,
    font/titleformat frame=#1,
    titleformat plain=#1,
  }
}
```

Set default values for options.

``` latex
\newcommand{\moloch@setdefaults}{
  \pgfkeys{/moloch/.cd,
    titleformat plain=regular,
  }
}
```

## Component Sub-Packages

Having processed the options, we can now load the component sub-packages
of the theme.

``` latex
\useinnertheme{moloch}
\useoutertheme{moloch}
\usecolortheme{moloch}
\usefonttheme{moloch}
```

## Custom Commands

The parent theme defines custom commands as their proper usage may
depend on multiple sub-packages.

### `\molochset`

Allows the user to change options midway through a presentation.

``` latex
\newcommand{\molochset}[1]{\pgfkeys{/moloch/.cd,#1}}
```

**DEPRECATED:** The following command is deprecated and will be removed
in a future version.

### `\mreducelistspacing`

``` latex
\newcommand{\mreducelistspacing}{%
  \PackageWarning{beamerthememoloch}{%
    \string\mreducelistspacing\space is deprecated and will be removed in a future version}%
  \vspace{-\topsep}%
}
```

## Process Package Options

``` latex
\moloch@setdefaults
\ProcessPgfOptions{/moloch}
```
