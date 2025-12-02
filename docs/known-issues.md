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
