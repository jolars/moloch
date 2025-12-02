---
title: "Color Theme: High Contrast"
---

::: {.callout-note}

**Source file:** [`src/beamercolorthememoloch-highcontrast.dtx`](https://github.com/jolars/moloch/blob/main/src/beamercolorthememoloch-highcontrast.dtx)

:::

This is a high-contrast variant of the Moloch color theme. It provides
better readability for users with visual impairments by using stark
color contrasts.

First, we load the base Moloch color theme.

``` latex
\usecolortheme{moloch}
```

Next, we define the high-contrast-specific colors.

``` latex
\definecolor{mAlert}{HTML}{AD003D}
\definecolor{mExample}{HTML}{005580}
```

## Registering Color Schemes

Register high-contrast-specific light and dark color schemes

``` latex
\moloch@register@light@colors{%
  \setbeamercolor{normal text}{fg=black,bg=white}%
}
\moloch@register@dark@colors{%
  \setbeamercolor{normal text}{fg=white,bg=black}%
}
```

## Color Adjustments

Apply high-contrast-specific color adjustments.

``` latex
\setbeamercolor{normal text}{%
  fg=black,
  bg=white
}
\setbeamercolor{alerted text}{%
  fg=mAlert,
}
\setbeamercolor{example text}{%
  fg=mExample,
}
```

Make sure the adjustments apply in all modes.

``` latex
\mode<all>
```
