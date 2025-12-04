---
title: "Color Theme: Tomorrow"
---

::: {.callout-note}

**Source file:** [`src/beamercolorthememoloch-tomorrow.dtx`](https://github.com/jolars/moloch/blob/main/src/beamercolorthememoloch-tomorrow.dtx)

:::

## Moloch Tomorrow Color Theme

**DEPRECATED:** This color theme is deprecated and will be removed in a
future version. Please use \|\| with \|\| instead.

The Moloch Tomorrow color theme provides a color scheme based on the
"Tomorrow" color scheme created by Chris Kempson.

This file now simply loads the base color theme and applies the tomorrow
preset.

``` latex
\PackageWarning{beamercolorthememoloch-tomorrow}{%
  This color theme is deprecated and will be removed in a future version.\MessageBreak
  Please use \string\usecolortheme{moloch} with \string\molochset{colortheme=tomorrow} instead%
}

\usecolortheme{moloch}

% Apply tomorrow theme with light variant (default behavior)
\moloch@colortheme@tomorrow
\moloch@colors@light

\mode<all>
```
