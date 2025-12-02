---
title: "Color Theme: Tomorrow"
---

::: {.callout-note}

**Source file:** [`src/beamercolorthememoloch-tomorrow.dtx`](https://github.com/jolars/moloch/blob/main/src/beamercolorthememoloch-tomorrow.dtx)

:::

## Moloch Tomorrow Color Theme

The Moloch Tomorrow color theme provides a color scheme based on the
"Tomorrow" color scheme created by Chris Kempson.

We use the base Moloch color theme as a foundation.

``` latex
\usecolortheme{moloch}
```

## Color Definitions

These are the color definitions for the Tomorrow color scheme.

``` latex
\definecolor{tomorrowForeground}{HTML}{1d1f21}
\definecolor{tomorrowBackground}{RGB}{255,255,255}
\definecolor{tomorrowHeader}{HTML}{1d1f21}
\definecolor{tomorrowAlert}{HTML}{cc6666}
\definecolor{tomorrowExample}{HTML}{4271ae}
\definecolor{tomorrowProgress}{HTML}{8959a8}
```

## Registering Color Schemes

Register tomorrow-specific light and dark color schemes

``` latex
\moloch@register@light@colors{%
  \setbeamercolor{normal text}{fg=tomorrowForeground,bg=tomorrowBackground}%
  \setbeamercolor{frametitle}{bg=tomorrowHeader}%
}
\moloch@register@dark@colors{%
  \setbeamercolor{normal text}{fg=tomorrowBackground,bg=tomorrowForeground}%
  \setbeamercolor{frametitle}{bg=tomorrowBackground}%
}
```

## Applying Color Schemes

Apply the colors according to the selected color scheme.

``` latex
\setbeamercolor{normal text}{fg=tomorrowForeground,bg=tomorrowBackground}
\setbeamercolor{moloch accent}{fg=tomorrowAccent}
\setbeamercolor{frametitle}{bg=tomorrowHeader}
\setbeamercolor{alerted text}{fg=tomorrowAlert}
\setbeamercolor{example text}{fg=tomorrowExample}
\setbeamercolor{progress bar}{fg=tomorrowProgress}
```

We also need to ensure that the color scheme is applied when switching
between light and dark modes.

``` latex
\mode<all>
```
