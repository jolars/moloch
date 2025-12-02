---
title: "Color Theme"
---

::: {.callout-note}

**Source file:** [`src/beamercolorthememoloch.dtx`](https://github.com/jolars/moloch/blob/main/src/beamercolorthememoloch.dtx)

:::

## Moloch Color Theme

### Package Dependencies

``` latex
\RequirePackage{pgfopts}
```

### Options

### `block`

Optionally adds a light grey background to block environments like
`theorem` and `example`.

``` latex
\pgfkeys{
  /moloch/color/block/.cd,
  .is choice,
  transparent/.code=\moloch@block@transparent,
  fill/.code=\moloch@block@fill,
}
```

### `colors`

Provides the option to have a dark background and light foreground
instead of the reverse.

``` latex
\pgfkeys{
  /moloch/color/background/.cd,
  .is choice,
  dark/.code=\moloch@colors@dark,
  light/.code=\moloch@colors@light,
}
```

### `\moloch@color@setdefaults`

Sets default values for color theme options.

``` latex
\newcommand{\moloch@color@setdefaults}{
  \pgfkeys{/moloch/color/.cd,
    background=light,
  }
}
```

### Base Colors

``` latex
\definecolor{mDarkBrown}{HTML}{604c38}
\definecolor{mDarkTeal}{HTML}{23373b}
\definecolor{mLightBrown}{HTML}{EB811B}
\definecolor{mLightGreen}{RGB}{0,128,128}
```

### Base Styles

All colors in Moloch are derived from the definitions of `normal text`,
`alerted text`, and `example text`.

``` latex
\setbeamercolor{alerted text}{%
  fg=mLightBrown
}
\setbeamercolor{example text}{%
  fg=mLightGreen
}
```

### Hooks for Color Themes

Moloch color themes can register light and dark color schemes using the
commands below. The registered colors will be stored in the macros
`\moloch@define@light@colors` and `\moloch@define@dark@colors`
respectively. These macros are invoked when the `background=light` or
`background=dark` options are selected.

``` latex
\newcommand{\moloch@define@light@colors}{}
\newcommand{\moloch@define@dark@colors}{}

\newcommand{\moloch@register@light@colors}[1]{%
  \renewcommand{\moloch@define@light@colors}{#1}%
}

\newcommand{\moloch@register@dark@colors}[1]{%
  \renewcommand{\moloch@define@dark@colors}{#1}%
}

\newcommand{\moloch@colors@dark}{
  \moloch@define@dark@colors
  \usebeamercolor[fg]{normal text}
}
\newcommand{\moloch@colors@light}{
  \moloch@define@light@colors
  \usebeamercolor[fg]{normal text}
}

\moloch@register@light@colors{%
  \setbeamercolor{normal text}{%
    fg=mDarkTeal,
    bg=black!2
  }%
}

\moloch@register@dark@colors{%
  \setbeamercolor{normal text}{%
    fg=black!2,
    bg=mDarkTeal
  }%
}
```

### Derived Colors

The titles and structural elements (e.g. `itemize` bullets) are set in
the same color as `normal text`. This would ideally done by setting
`normal text` as a parent style, which we do to set `titlelike`, but
this doesn't work for `structure` as its foreground is set explicitly in
`beamercolorthemedefault.sty`.

``` latex
\setbeamercolor{titlelike}{use=normal text, parent=normal text}
\setbeamercolor{author}{use=normal text, parent=normal text}
\setbeamercolor{date}{use=normal text, parent=normal text}
\setbeamercolor{institute}{%
  use=normal text, fg=normal text.fg!80!normal text.bg}
\setbeamercolor{structure}{use=normal text, fg=normal text.fg}
\setbeamercolor{thanks}{%
  use=normal text,fg=normal text.fg!80!normal text.bg}
```

The "primary" palette should be used for the most important navigational
elements, and possibly of other elements. Moloch uses it for frame
titles and slides.

``` latex
\setbeamercolor{palette primary}{%
  use=normal text,
  fg=normal text.bg,
  bg=normal text.fg
}
\setbeamercolor{frametitle}{%
  use=palette primary,
  parent=palette primary
}
```

The Moloch inner or outer themes optionally display progress bars in
various locations. Their color is set by `progress bar` but the two
different kinds can be customized separately. The horizontal rule on the
title page is also set based on the progress bar color and can be
customized with `title separator`.

``` latex
\setbeamercolor{progress bar}{%
  use=alerted text,
  fg=alerted text.fg,
  bg=alerted text.fg!50!black!30
}
\setbeamercolor{title separator}{
  use=progress bar,
  parent=progress bar
}
\setbeamercolor{progress bar in head/foot}{%
  use=progress bar,
  parent=progress bar
}
\setbeamercolor{progress bar in section page}{
  use=progress bar,
  parent=progress bar
}
```

Block environments such as `theorem` and `example` have no background
color by default. The option `block=fill` sets a background color based
on the background and foreground of `normal text`. The option
`block=transparent` reverts the block environments to an empty
background, which can be useful if changing colors mid-presentation.

``` latex
\newcommand{\moloch@block@transparent}{
  \setbeamercolor{block title}{bg=}
  \setbeamercolor{block body}{bg=}
  \setbeamercolor{block title alerted}{bg=}
  \setbeamercolor{block title example}{bg=}
}
\newcommand{\moloch@block@fill}{
  \setbeamercolor{block title}{%
    bg=normal text.bg!80!fg
  }
  \setbeamercolor{block body}{%
    use=block title,
    bg=block title.bg!50!normal text.bg
  }
  \setbeamercolor{block title alerted}{%
    bg=block title.bg,
  }
  \setbeamercolor{block title example}{%
    bg=block title.bg,
  }
}
\setbeamercolor{block title}{%
  use=normal text,
  fg=normal text.fg
}
\setbeamercolor{block title alerted}{%
  use={block title, alerted text},
  fg=alerted text.fg
}
\setbeamercolor{block title example}{%
  use={block title, example text},
  fg=example text.fg
}
\setbeamercolor{block body alerted}{use=block body, parent=block body}
\setbeamercolor{block body example}{use=block body, parent=block body}
```

Footnotes

``` latex
\setbeamercolor{footnote}{fg=normal text.fg!90}
\setbeamercolor{footnote mark}{fg=.}
```

We also reset the bibliography colors in order to pick up the
surrounding colors at the time of use. This prevents us having to set
the correct color in normal and standout mode.

``` latex
\setbeamercolor{bibliography entry author}{fg=, bg=}
\setbeamercolor{bibliography entry title}{fg=, bg=}
\setbeamercolor{bibliography entry location}{fg=, bg=}
\setbeamercolor{bibliography entry note}{fg=, bg=}
```

### Process Package Options

``` latex
\moloch@color@setdefaults
\ProcessPgfPackageOptions{/moloch/color}
```

``` latex
\mode<all>
```
