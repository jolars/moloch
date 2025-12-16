---
title: "Inner Theme"
---

::: {.callout-note}

**Source file:** [`src/beamerinnerthememoloch.dtx`](https://github.com/jolars/moloch/blob/main/src/beamerinnerthememoloch.dtx)

:::

The `beamer` inner theme dictates the style of the frame elements
traditionally set in the "body" of each slide.

## Package Dependencies

``` latex
\RequirePackage{keyval}
\RequirePackage{calc}
\RequirePackage{pgfopts}
\RequirePackage{tikz}
```

## Memoization and Tikz Externalization

See the documentation for the correspondign section under the outer
theme for more information on the following lines.

``` latex
\providecommand{\tikzexternalenable}{}
\providecommand{\tikzexternaldisable}{}
\providecommand{\mmzUnmemoizable}{}
```

## Options

### `sectionpage`

Optionally add a slide marking the beginning of each section.

``` latex
\pgfkeys{
  /moloch/inner/sectionpage/.cd,
  .is choice,
  none/.code=\moloch@disablesectionpage,
  simple/.code={%
      \moloch@enablesectionpage%
      \setbeamertemplate{section page}[simple]%
    },
  progressbar/.code={%
      \moloch@enablesectionpage%
      \setbeamertemplate{section page}[progressbar]%
    },
}
```

### `subsectionpage`

Optionally add a slide marking the beginning of each subsection.

``` latex
\pgfkeys{
  /moloch/inner/subsectionpage/.cd,
  .is choice,
  none/.code=\moloch@disablesubsectionpage,
  simple/.code={%
      \moloch@enablesubsectionpage%
      \setbeamertemplate{section page}[simple]%
    },
  progressbar/.code={%
      \moloch@enablesubsectionpage%
      \setbeamertemplate{section page}[progressbar]%
    },
}
```

### `standoutnumbering`

Whether or not to number standout pages. Option `none` means that
standout pages are not numbered (do not count as frames). `hide` means
that they do count as frames, but that the footer with the number is not
shown. Option `show` means that they both count as frames and that the
footer with a frame count is shown.

``` latex
\providebool{moloch@enableStandoutFooter}
\providebool{moloch@enableStandoutNumbering}
\pgfkeys{
  /moloch/inner/standoutnumbering/.cd,
  .is choice,
  none/.code={
      \boolfalse{moloch@enableStandoutNumbering}
      \boolfalse{moloch@enableStandoutFooter}
    },
  show/.code={
      \booltrue{moloch@enableStandoutNumbering}
      \booltrue{moloch@enableStandoutFooter}
    },
  hide/.code={
      \booltrue{moloch@enableStandoutNumbering}
      \boolfalse{moloch@enableStandoutFooter}
    }
}
```

### `titleseparator linewidth`

Set the width of the line separating the title from the author.

``` latex
\newlength{\moloch@titleseparator@linewidth}
\pgfkeys{
  /moloch/inner/.cd,
  titleseparatorlinewidth/.code={\setlength{\moloch@titleseparator@linewidth}{#1}},
}
```

### `titleseparator aliases`

Allows `titleseparator linewidth` to be used in `\usetheme`.

``` latex
\pgfkeys{
  /moloch/inner/.cd,
  titleseparator linewidth/.code=\pgfkeysalso{titleseparatorlinewidth=#1},
}
```

### `\moloch@inner@setdefaults`

Set default values for inner theme options.

``` latex
\newcommand{\moloch@inner@setdefaults}{
  \pgfkeys{/moloch/inner/.cd,
    sectionpage=progressbar,
    subsectionpage=none,
    standoutnumbering=none,
    titleseparator linewidth=0.5pt,
  }
}
```

## Title Page

### `title page`

Template for the title page. Each element is only typset if it is
defined by the user. If `\subtitle` is empty, for example, it won't
leave a blank space on the title slide.

``` latex
\setbeamertemplate{title page}{
  \null%
  \vspace{0pt plus 1.618fil}%
  \vfil%
  \ifx\inserttitlegraphic\@empty\else\usebeamertemplate*{title graphic}\fi
  \ifx\inserttitle\@empty\else\usebeamertemplate*{title}\fi
  \ifx\insertsubtitle\@empty\else\usebeamertemplate*{subtitle}\fi
  \usebeamertemplate*{title separator}
  \expandafter\ifblank\expandafter{\beamer@andstripped}{}{%
    \usebeamertemplate*{author}%
  }
  \ifx\insertinstitute\@empty\else\usebeamertemplate*{institute}\fi
  \ifx\insertdate\@empty\else\usebeamertemplate*{date}\fi
  \vspace{0pt plus 1fil}%
  \null
}
```

Normal people should use `\maketitle` or `\titlepage` instead of using
the `title page` beamer template directly. Beamer already defines these
macros, but we patch them here to make the title page `[plain]` by
default and ensure the title frame number doesn't count.

### `\maketitle`

Inserts the title frame, or causes the current frame to use the
`title page` template. Since we want to remove the footnote rule from
the title page, we have to store and restore it around the call to
`\frame`.

``` latex
\def\maketitle{%
  \ifbeamer@inframe
    \titlepage
  \else
    \let\beamer@saved@footnoterule\footnoterule%
    \renewcommand\footnoterule{}%
    \frame[plain,noframenumbering]{\titlepage}%
    \let\footnoterule\beamer@saved@footnoterule%
  \fi
}
```

Also patch `\titlepage` to ensure that footnotes on the title page are
formatted correctly.

### `\titlepage`

Inserts the title page using the `title page` beamer template.

``` latex
\def\titlepage{%
  % Apply title-page specific footnote settings
  \renewcommand{\@makefntext}[1]{%
    {\par\usebeamercolor[fg]{thanks}\usebeamerfont{thanks}$^{\@thefnmark}$##1\medskip}%
  }

  % Process the title page
  \usebeamertemplate{title page}\@thanks
}
```

### `title graphic`

Set the title graphic in a zero-height box, so it doesn't change the
position of other elements.

``` latex
\setbeamertemplate{title graphic}{
  \inserttitlegraphic%
  \par%
  \vspace*{1em}
}
```

### `title`

Set the title on the title page.

``` latex
\setbeamertemplate{title}{
  \raggedright%
  \moloch@titleformat{\inserttitle}%
  \par%
}
```

### `subtitle`

Set the subtitle on the title page.

``` latex
\setbeamertemplate{subtitle}{
  \vspace*{0.3em}
  \raggedright%
  \moloch@subtitleformat{\insertsubtitle}%
  \par%
}
```

### `title separator`

Template to set the title separator.

``` latex
\setbeamertemplate{title separator}{
  \tikzexternaldisable%
  \begin{tikzpicture}[baseline=(current bounding box.north)]
    \mmzUnmemoizable%
    \fill[fg] (0,0) rectangle (\textwidth, \moloch@titleseparator@linewidth);
    \useasboundingbox (0,0) rectangle (\textwidth,-\moloch@titleseparator@linewidth);
  \end{tikzpicture}%
  \tikzexternalenable%
  \par%
  \vspace*{0.8em}
}
```

### `author`

Set the author on the title page.

``` latex
\setbeamertemplate{author}{
  \raggedright%
  \insertauthor%
  \par%
  \vspace*{0.5em}
}
```

### `institute`

Set the institute on the title page.

``` latex
\setbeamertemplate{institute}{
  \insertinstitute%
  \par%
  \vspace*{1em}
}
```

### `date`

Set the date on the title page.

``` latex
\setbeamertemplate{date}{
  \insertdate%
  \par%
}
```

## Section Pages

### `section Page`

Template for the section title slide at the beginning of each section.

``` latex
\defbeamertemplate{section page}{simple}{
  \begin{center}
    \usebeamercolor[fg]{section title}
    \usebeamerfont{section title}
    \moloch@sectiontitleformat{\insertsectionhead}\par
    \usebeamercolor[fg]{subsection title}%
    \usebeamerfont{subsection title}%
    \strut%
    \ifx\insertsubsectionhead\@empty\else%
      \insertsubsectionhead%
    \fi
  \end{center}
  \vspace{\baselineskip - 1ex + \moloch@titleseparator@linewidth}
}
\defbeamertemplate{section page}{progressbar}{
  \centering
  \begin{minipage}{0.7875\linewidth}
    \raggedright
    \usebeamercolor[fg]{section title}
    \usebeamerfont{section title}
    \moloch@sectiontitleformat{\insertsectionhead}\\[-0.5\baselineskip]
    \usebeamertemplate*{progress bar in section page}
    \par
    \usebeamercolor[fg]{subsection title}%
    \usebeamerfont{subsection title}%
    \strut%
    \ifx\insertsubsectionhead\@empty\else%
      \insertsubsectionhead%
    \fi
  \end{minipage}
  \par
}
\newcommand{\moloch@disablesectionpage}{
  \AtBeginSection{
    % intentionally empty
  }
}
\newcommand{\moloch@enablesectionpage}{
  \AtBeginSection{
    \ifbeamer@inframe
      \sectionpage
    \else
      \frame[plain,c,noframenumbering]{\sectionpage}
    \fi
  }
}
```

### `subsection page`

Template for the subsection title slide that can optionally be added to
at the beginning of each subsection.

``` latex
\setbeamertemplate{subsection page}{%
  \usebeamertemplate*{section page}
}
\newcommand{\moloch@disablesubsectionpage}{
  \AtBeginSubsection{
    % intentionally empty
  }
}
\newcommand{\moloch@enablesubsectionpage}{
  \AtBeginSubsection{
    \ifbeamer@inframe
      \subsectionpage
    \else
      \frame[plain,c,noframenumbering]{\subsectionpage}
    \fi
  }
}
```

### `progress bar in section page`

Template for the progress bar displayed by default on the section page.
This code is duplicated in large part in the outer theme's template
`progress bar in head/foot`.

``` latex
\setbeamertemplate{progress bar in section page}{
  \pgfmathsetlength{\moloch@progressonsectionpage}{
    \textwidth * min(1,\insertframenumber/max(1,\inserttotalframenumber))
  }%
  \tikzexternaldisable%
  \begin{tikzpicture}[baseline=(current bounding box.north)]
    \mmzUnmemoizable%
    \fill[bg]
    (0,0)
    rectangle
    (\textwidth, \moloch@progressonsectionpage@linewidth);
    \fill[fg]
    (0,0)
    rectangle
    (\moloch@progressonsectionpage,
    \moloch@progressonsectionpage@linewidth);
    \useasboundingbox (0,0) rectangle (\textwidth,-\moloch@progressonsectionpage@linewidth);
  \end{tikzpicture}%
  \tikzexternalenable%
}
```

The code above assumes that `\insertframenumber` is less than or equal
to `\inserttotalframenumber`. However, this is not true on the first
compile; in the absence of an `.aux` file, `\inserttotalframenumber`
defaults to 1. This behaviour could cause fatal errors for long
presentations, as `\moloch@progressonsectionpage` would exceed TeX's
maximum length (16383.99999pt, roughly 5.75 metres or 18.9 feet). To
avoid this, we increase the default value for `\inserttotalframenumber`;
presentations with over 4000 slides will still break on first compile,
but users in that situation likely have deeper problems to solve.

``` latex
\def\inserttotalframenumber{100}
```

## Lists and Floats

Moloch uses custom symbols for the `itemize` environment. The symbols
are defined as below, using `pgf` commands to draw the shapes. This is
slightly different than what beamer does by default, which is to use
font glyphs from the math font. But we want to avoid this reliance on
the math font, which may have somewhat surprising side effects.

By default, we use a filled circle for the first-level `itemize` items,
a filled square for the second level, and a filled triangle for the
third level. Since the triangle tapers to a point, we add a slight
overhang to it so that it visually aligns better with the other symbols.
We do the same for the circle, but to a lower extent.

``` latex
\newcommand{\mitemover}[2]{\makebox[0pt][r]{#1}\kern-#2}
\newcommand{\mitem}[1]{\mitemover{#1}{0pt}}

\newcommand{\overhangSquare}{0pt}
\newcommand{\overhangCircle}{0.05ex}
\newcommand{\overhangTriangle}{0.25ex}

\newcommand{\moloch@circle}{
  \begin{pgfpicture}
    \pgfsetbaseline{-0.7ex}
    \pgfpathcircle{\pgfpoint{0}{0}}{0.16em}
    \pgfusepath{fill}
  \end{pgfpicture}%
}
%
\newcommand{\moloch@square}{
  \begin{pgfpicture}
    \pgfsetbaseline{-0.7ex}
    \pgfpathrectangle{\pgfpoint{-0.165em}{-0.165em}}{\pgfpoint{0.31em}{0.31em}}
    \pgfusepath{fill}
  \end{pgfpicture}%
}
%
\newcommand{\moloch@triangle}{
  \begin{pgfpicture}
    \pgfsetbaseline{-0.7ex}
    \pgfpathmoveto{\pgfpoint{0.21em}{0}}       % right vertex (tip)
    \pgfpathlineto{\pgfpoint{-0.21em}{0.21em}}  % top left
    \pgfpathlineto{\pgfpoint{-0.21em}{-0.21em}} % bottom left
    \pgfpathclose
    \pgfusepath{fill}
  \end{pgfpicture}%
}
```

Next, we set the itemize templates to use these symbols.

``` latex
% \setbeamertemplate{itemize item}[circle]
\setbeamertemplate{itemize item}{\mitemover{\moloch@circle}{\overhangCircle}}
\setbeamertemplate{itemize subitem}{\mitemover{\moloch@square}{\overhangSquare}}
\setbeamertemplate{itemize subsubitem}{\mitemover{\moloch@triangle}{\overhangTriangle}}
\setbeamertemplate{caption label separator}{: }
\setbeamertemplate{caption}[numbered]
```

## Footnotes

``` latex
\setbeamertemplate{footnote}{%
  \parindent 0em\noindent\raggedright \usebeamercolor{footnote}\hbox to
  0.8em{\hfil\insertfootnotemark}\insertfootnotetext%%%
  \par%
}
```

## Text and Spacing Settings

By default, Beamer frames offer the `c` option to *almost* vertically
center the text, but the placement is a little too high. To fix this, we
redefine the `c` option to equalize `\beamer@frametopskip` and
`\beamer@framebottomskip`. This solution was suggested by Enrico
Gregorio in an answer to [this Stack Exchange
question](http://tex.stackexchange.com/questions/247826/).

``` latex
\define@key{beamerframe}{c}[true]{% centered
  \beamer@frametopskip=0pt plus 1fil\relax%
  \beamer@framebottomskip=0pt plus 1fil\relax%
  \beamer@frametopskipautobreak=0pt plus .4\paperheight\relax%
  \beamer@framebottomskipautobreak=0pt plus .6\paperheight\relax%
  \def\beamer@initfirstlineunskip{}%
}
```

## Standout Frames

Moloch offers a custom frame format with large, centered text and an
inverted background. To use it, add the key `standout` to the frame:

`\begin{frame}[standout] ... \end{frame}`.

### `standout`

Optional arguments to Beamer's frames are implemented using
`\define@key` from the `keyval` package, which will execute code when
the defined option is called. For the `standout` option, we begin a
group, change the colors and set frame options.

``` latex
\providebool{moloch@standout}
\define@key{beamerframe}{standout}[true]{%
  \booltrue{moloch@standout}
  \begingroup
  \setkeys{beamerframe}{c}
  \ifbool{moloch@enableStandoutNumbering}{}{%
    \setkeys{beamerframe}{noframenumbering}}
  \ifbeamercolorempty[bg]{standout}{
    \setbeamercolor{background canvas}{
      use=standout,
      bg=-standout.fg
    }
  }{
    \setbeamercolor{background canvas}{
      use=standout,
      bg=standout.bg
    }
  }
  \setbeamercolor{local structure}{
    fg=standout.fg
  }
  \usebeamercolor[fg]{standout}
  \setbeamercolor{page number in head/foot}{
    use=standout,
    fg=standout.fg
  }
  \ifbool{moloch@enableStandoutFooter}{}{\setbeamertemplate{footline}{}}
}
```

Then we just have to close the group after the standout slide is
finished in order to restore the colours and fonts for the rest of the
presentation. Unfortunately, we cannot use `\AfterEndEnvironment{frame}`
for this (see <http://tex.stackexchange.com/questions/226319/>).
Instead, we prepend the `\endgroup` to `\beamer@reseteecodes`, which is
run exactly once at the end of each slide.

``` latex
\pretocmd{\beamer@reseteecodes}{%
  \ifbool{moloch@standout}{
    \endgroup
    \boolfalse{moloch@standout}
  }{}
}{}{}
```

We set the fonts and the `\centering` alignment on the inner content, in
such a way that the speaker's note layout isn't affected by the custom
formatting.

``` latex
\AtBeginEnvironment{beamer@frameslide}{
  \ifbool{moloch@standout}{
    \centering
    \usebeamerfont{standout}
  }{}
}
```

## Process Package Options

``` latex
\moloch@inner@setdefaults
\ProcessPgfPackageOptions{/moloch/inner}
```
