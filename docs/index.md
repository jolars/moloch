# Introduction

Beamer is a great way to make presentations with LaTeX, but its theme selection
is surprisingly sparse. The stock themes share an aesthetic that can be a little
cluttered, while the few distinctive custom themes available are often
specialized for a particular corporate or institutional brand.

The goal of Moloch is to provide a simple, modern Beamer theme suitable for
anyone to use. It tries to minimize noise and maximize space for content; the
only visual flourish it offers is an (optional) progress bar added to each slide
or to the section slides.

Moloch's codebase is maintained at <https://github.com/jolars/moloch>. If you
have any issues, find mistakes in the manual or want to help make the theme even
better, please get in touch there.

Moloch is a fork of the popular Metropolis theme by Matthias Vogelgesang. The
motivation for the fork was to fix some longstanding bugs in Metropolis and also
simplify the codebase to make it easier to maintain and less fragile to changes
in the underlying Beamer code.

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

# Customization

## Package Options

The theme provides a number of options, which can be set using a key=value
interface. The primary way to set options is to provide a comma-separated list
of option-value pairs when loading Moloch in the preamble:

```latex
\usetheme[
    option1=value1,
    option2=value2,
    ...
]{moloch}
```

Options can be changed at any time---even mid-presentation---with the
`molochset()` macro.

```latex
\molochset{
    option1=newvalue1,
    option2=newvalue2,
    ...
}
```

The list of options is structured as shown in the following example.

::: {.describe-option option-name="<option-name>" values="<list>, <of>,
<values>" default="<default>"}

A short description of the option.

:::

### Main Theme

::: {.describe-option option-name="titleformat" values="regular, smallcaps,
allsmallcaps, allcaps" default="regular"}

Changes the format of titles, subtitles, section titles, frame titles, and the
text on "standout" frames. The available options produce Regular,
[SmallCaps]{.smallcaps}, [allsmallcaps]{.smallcaps}, or ALLCAPS titles. Note
that these commands do not affect math and numbers, so may not work as you
expect if your titles contain these.

:::

::: {.describe-option option-name="standoutnumberformat" values="regular,
smallcaps, allsmallcaps, allcaps" default="regular"}

Changes the format of "standout" frames (see `titleformat`, above).

:::

### Inner Theme

::: {.describe-option option-name="sectionpage" values="none, simple,
progressbar" default="progressbar"}

Adds a slide at the start of each section (`simple`) with an optional thin
progress bar below the section title (`progressbar`). The `none` option disables
the section page.

:::

::: {.describe-option option-name="subsectionpage" values="none, simple,
progressbar" default="none"}

Optionally adds a slide at the start of each subsection. If enabled with the
`simple` or `progressbar` options, the style of the `section page` will be
updated to match the style of the `subsection page`. Note that section slides
and subsection slides can appear consecutively if both are enabled; you may want
to use this option together with `sectionpage=none` depending on the section
structure of your presentation.

:::

::: {.describe-option option-name="standoutnumbering" values="none, hide, show"
default="none"}

This option decides whether or not to count standout pages as frames if frame
counting. Option `none` (the default) means that the standout frames are not
counted. `hide` means that they are counted but that there won't be any footer
showing a frame number. `show` means that they are counted and that the frame
number count is shown in the same fashion as for regular frames.

:::

### Outer Theme

::: {.describe-option option-name="numbering" values="none, counter, fraction"
default="(none specified)"}

_This option is deprecated and will be removed in a future version. Please use
Beamer's `page number in head/foot` template instead._ Controls whether the
frame number at the bottom right of each slide is omitted (`none`), shown
(`counter`) or displayed as a fraction of the total number of frames
(`fraction`).

:::

::: {.describe-option option-name="progressbar" values="none, head, frametitle,
foot" default="none"}

Optionally adds a progress bar to the top of each frame (`head`), the bottom of
each frame (`foot`), or directly below each frame title (`frametitle`).

:::

### Color Theme

::: {.describe-option option-name="block" values="transparent, fill"
default="transparent"}

Optionally adds a light grey background to block environments like `theorem` and
`example`.

:::

::: {.describe-option option-name="background" values="dark, light"
default="light"}

Provides the option to have a dark background and light foreground instead of
the reverse.

:::

### Font Theme

::: {.describe-option option-name="titleformat plain, titleformat frametitle,
titleformat section" values="regular, smallcaps, allsmallcaps, allcaps"
default="regular"}

Individually controls the format of titles, subtitles, section titles, and frame
titles (see `titleformat`, above).

:::

## Color Customization

The included Moloch color theme is used by default, but its colors can be easily
changed to suit your tastes. All of the theme's styles are defined in terms of
three beamer colors:

- `normal text` (dark fg, light bg)
- `alerted text` (colored fg, should be visible against dark or light)
- `example text` (colored fg, should be visible against dark or light)

An easy way to customize the theme is to redefine these colors using

```latex
\setbeamercolor{ ... }{ fg= ... , bg= ... }
```

in your preamble. For greater customization, you can redefine any of the other
stock beamer colors. In addition to the stock colors the theme defines a number
of Moloch specific colors, which can also be redefined to your liking.

```latex
\setbeamercolor{progress bar}{ ... }
\setbeamercolor{title separator}{ ... }
\setbeamercolor{progress bar in head/foot}{ ... }
\setbeamercolor{progress bar in section page}{ ... }
```

### Themes

For low-light situations Moloch it might be helpful to use the
`moloch-highcontrast` color theme. It is enabled like any other color theme:

```latex
\usecolortheme{moloch-highcontrast}
```

There is also a theme based on the
[https://github.com/chriskempson/tomorrow-theme](tomorrow color theme), which
you can enable like this:

```latex
\usecolortheme{moloch-tomorrow}
```

## Commands

### Standout Frames

The Moloch inner theme offers a custom frame format with large, centered text
and an inverted background---perfect for focusing attention on single sentence
or image. To use it, add the key `standout` to the frame:

```latex
\begin{frame}[standout]
    Thank you!
\end{frame}
```

# Known Issues

## Title Formats

Be aware that not every font supports small caps, so the `smallcaps` or
`allsmallcaps` options may not work for all fonts. In particular, the Computer
Modern sans-serif typeface, which is used by default when Moloch is compiled
with pdfLaTeX, does not have a small-caps variant.

Note that title format options `allsmallcaps` and `allcaps` do not affect the
sizes of numerals, punctuation, and math symbol, and are probably best avoided
if your titles contain these characters.

## Interactions with Other Color Themes

Moloch can be used along with any other Beamer color theme, such as `crane` or
`seahorse`. If you wish to do this, it is usually best to include the Moloch
subpackages individually so the Moloch color theme is never loaded. This will
prevent conflicts between the Moloch color theme and your preferred theme.

For example, overriding the color theme as follows may not work as expected
because
``loads the Moloch color theme, which defines a relationship between the frametitle background and the primary palette of the theme. Since`seahorse`
assumes a different relationship between its palettes, the result is a grey,
rather than periwinkle, frametitle background.

```latex
\usetheme{moloch}
\usecolortheme{seahorse}
```

The correct colors are chosen if the Moloch outer, inner, and font themes are
loaded seperately:

```latex
\useoutertheme{moloch}
\useinnertheme{moloch}
\usefonttheme{moloch}
\usecolortheme{seahorse}   % or your preferred color theme
```

Please note that Moloch may not use all the colors defined in your favourite
Beamer color theme. In particular, Moloch does not set a background color for
the title; this will cause issues when using color themes like `whale` which set
a white foreground for the title.

## Notes on Second Screen

If you use the `[show notes on second screen]` option built in to Beamer and
compile with XeLaTeX, text on slides following the first section slide may be
rendered in white instead of the regular colour. This is due to
[a bug](http://tex.stackexchange.com/questions/288408/) in Beamer or  itself.
You can work around it either by compiling with  or by adding the following code
to your preamble to reset the text color on each slide.

```latex
\makeatletter
\def\beamer@framenotesbegin{% at beginning of slide
  \usebeamercolor[fg]{normal text}
  \gdef\beamer@noteitems{}%
  \gdef\beamer@notes{}%
}
\makeatother
```

## Standout Frames with Labels

Because the `standout` frame option creates a group to restrict the colour
change to a single slide, labels defined after calling `standout` will stay
local to the group. In other words, the following may result in a "label
undefined" error.

```latex
\begin{frame}[standout, label=conclusion]{Conclusion}
  Awesome slide
\end{frame}
```

To fix this problem, change the order of the keys in the frame.

```latex
\begin{frame}[label=conclusion, standout]{Conclusion}
  Awesome slide
\end{frame}
```

This error can be unwittingly triggered if you export your slides from Emacs Org
mode, which automatically adds labels after frame options. Alex Branham
[offers](https://github.com/matze/mtheme/issues/203) the following solution for
Org mode users, using `org-set-property`.

```org
* Start of a frame
    :PROPERTIES:
    :BEAMER_opt: label=conclusion,standout
    :END:
```

## Standout Frames with Pandoc

With Pandoc versions prior to 1.17.2 it was not possible to create standout
frames because Pandoc only supported a specific list of frame attributes thus
ignoring additional attributes such as `.standout`.

## License

Moloch is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).
This means that if you change the theme and re-distribute it, you must retain
the copyright notice header and license it under the same CC-BY-SA license. This
does not affect any presentations that you create with the theme.

## Implementation

[^1]:
    Matthias wrote the original version of this manual for the Metropolis theme,
    which has since been modified by Johan Larsson.
