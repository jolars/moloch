---
title: "Color Theme: High Contrast"
---

::: {.callout-note}

**Source file:** [`src/beamercolorthememoloch-highcontrast.dtx`](https://github.com/jolars/moloch/blob/main/src/beamercolorthememoloch-highcontrast.dtx)

:::

**DEPRECATED:** This color theme is deprecated and will be removed in a
future version. Please use \|\| with \|\| instead.

This is a high-contrast variant of the Moloch color theme. It provides
better readability for users with visual impairments by using stark
color contrasts.

This file now simply loads the base color theme and applies the
highcontrast preset.

``` latex
\PackageWarning{beamercolorthememoloch-highcontrast}{%
  This color theme is deprecated and will be removed in a future version.\MessageBreak
  Please use \string\usecolortheme{moloch} with \string\molochset{colortheme=highcontrast} instead%
}

\usecolortheme{moloch}

% Apply highcontrast theme with light variant (default behavior)
\moloch@colortheme@highcontrast
\moloch@colors@light

\mode<all>
```
