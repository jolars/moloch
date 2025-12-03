---
applyTo: "src/beamercolorthememoloch.dtx"
---

# Moloch Color Theme Architecture

This document explains how the color system in `beamercolorthememoloch.dtx` works, making it easy to add new color customization options.

## Overview

The color system has three main components:

1. **Color Theme Presets** - Define complete color schemes (default, tomorrow, highcontrast)
2. **Variant System** - Support light/dark variants with automatic switching
3. **Granular Color Options** - Allow users to override individual colors per variant

## Key Architecture Concepts

### 1. Variant Tracking

A boolean flag tracks the current variant:

```tex
\newif\ifmoloch@variant@dark
\moloch@variant@darkfalse  % Default to light variant
```

### 2. Color Registration System

Each color theme preset registers both light and dark variants:

```tex
\moloch@register@light@colors{%
  \setbeamercolor{normal text}{fg=mDarkTeal, bg=black!2}%
  \setbeamercolor{frametitle}{fg=black!2, bg=mDarkTeal}%
  % ... more colors
}

\moloch@register@dark@colors{%
  \setbeamercolor{normal text}{fg=black!2, bg=mDarkTeal}%
  \setbeamercolor{frametitle}{fg=mDarkTeal, bg=black!2}%
  % ... more colors
}
```

### 3. Variant Switching

Two commands apply the registered colors:

```tex
\newcommand{\moloch@colors@light}{%
  \moloch@define@light@colors
  \moloch@setup@text@colors
  \moloch@setup@block@colors
  \moloch@apply@store@light@colors
}

\newcommand{\moloch@colors@dark}{%
  \moloch@define@dark@colors
  \moloch@setup@text@colors
  \moloch@setup@block@colors
  \moloch@apply@store@dark@colors
}
```

### 4. Storage System for User Customizations

User color customizations are stored in macros so they persist across variant switches. For each customizable color, there are storage macros for both variants:

```tex
\moloch@store@light@<color>@<property>
\moloch@store@dark@<color>@<property>
```

Example: `\moloch@store@light@alerted@text`, `\moloch@store@dark@normal@text@fg`

### 5. Application Functions

Two functions apply stored customizations after switching variants:

- `\moloch@apply@store@light@colors` - Apply light variant customizations
- `\moloch@apply@store@dark@colors` - Apply dark variant customizations

These check if each storage macro is non-empty and apply it if set.

## How to Add a New Color Option

Follow these steps to add a new customizable color option. We'll use `normal text fg` as an example.

### Step 1: Add Storage Macro Definitions

In the `/moloch/colors/.cd` pgfkeys section (~line 470), add storage keys:

```tex
store/light/<color name>/.store in=\moloch@store@light@<macro@name>,
store/dark/<color name>/.store in=\moloch@store@dark@<macro@name>,
```

**Example:**
```tex
store/light/normal text fg/.store in=\moloch@store@light@normal@text@fg,
store/dark/normal text fg/.store in=\moloch@store@dark@normal@text@fg,
```

**Naming convention:**
- Use full Beamer color name for `<color name>` (e.g., "normal text fg", "alerted text", "progress bar")
- Replace spaces with `@` in `<macro@name>` (e.g., `normal@text@fg`, `alerted@text`, `progress@bar`)

### Step 2: Initialize Storage Macros

After the `.store in=` definitions (~line 495), initialize to empty:

```tex
store/light/<color name>=,
store/dark/<color name>=,
```

**Example:**
```tex
store/light/normal text fg=,
store/dark/normal text fg=,
```

### Step 3: Add Color Setting Options

After the initialization section (~line 515), add three option variants:

#### a) Variant-agnostic option (sets current variant + stores)

```tex
<color name>/.code={%
    \setbeamercolor{<beamer color>}{<property>=#1}%
    % Call any necessary setup functions
    \ifmoloch@variant@dark
      \pgfkeys{/moloch/colors/store/dark/<color name>=#1}%
    \else
      \pgfkeys{/moloch/colors/store/light/<color name>=#1}%
    \fi
  },
```

#### b) Light-specific option (stores + applies if in light mode)

```tex
light/<color name>/.code={%
    \pgfkeys{/moloch/colors/store/light/<color name>=#1}%
    \ifmoloch@variant@dark\else
      \setbeamercolor{<beamer color>}{<property>=#1}%
      % Call any necessary setup functions
    \fi
  },
```

#### c) Dark-specific option (stores + applies if in dark mode)

```tex
dark/<color name>/.code={%
    \pgfkeys{/moloch/colors/store/dark/<color name>=#1}%
    \ifmoloch@variant@dark
      \setbeamercolor{<beamer color>}{<property>=#1}%
      % Call any necessary setup functions
    \fi
  },
```

**Example for `normal text fg`:**
```tex
normal text fg/.code={%
    \setbeamercolor{normal text}{fg=#1}%
    \moloch@setup@text@colors
    \moloch@setup@block@colors
    \ifmoloch@variant@dark
      \pgfkeys{/moloch/colors/store/dark/normal text fg=#1}%
    \else
      \pgfkeys{/moloch/colors/store/light/normal text fg=#1}%
    \fi
  },
light/normal text fg/.code={%
    \pgfkeys{/moloch/colors/store/light/normal text fg=#1}%
    \ifmoloch@variant@dark\else
      \setbeamercolor{normal text}{fg=#1}%
      \moloch@setup@text@colors
      \moloch@setup@block@colors
    \fi
  },
dark/normal text fg/.code={%
    \pgfkeys{/moloch/colors/store/dark/normal text fg=#1}%
    \ifmoloch@variant@dark
      \setbeamercolor{normal text}{fg=#1}%
      \moloch@setup@text@colors
      \moloch@setup@block@colors
    \fi
  },
```

### Step 4: Update Application Functions

Add to `\moloch@apply@store@light@colors` (~line 213):

```tex
\ifx\moloch@store@light@<macro@name>\empty\else
  \setbeamercolor{<beamer color>}{<property>=\moloch@store@light@<macro@name>}%
  % Call any necessary setup functions
\fi
```

Add to `\moloch@apply@store@dark@colors` (~line 251):

```tex
\ifx\moloch@store@dark@<macro@name>\empty\else
  \setbeamercolor{<beamer color>}{<property>=\moloch@store@dark@<macro@name>}%
  % Call any necessary setup functions
\fi
```

**Example:**
```tex
% In \moloch@apply@store@light@colors:
\ifx\moloch@store@light@normal@text@fg\empty\else
  \setbeamercolor{normal text}{fg=\moloch@store@light@normal@text@fg}%
  \moloch@setup@text@colors
  \moloch@setup@block@colors
\fi

% In \moloch@apply@store@dark@colors:
\ifx\moloch@store@dark@normal@text@fg\empty\else
  \setbeamercolor{normal text}{fg=\moloch@store@dark@normal@text@fg}%
  \moloch@setup@text@colors
  \moloch@setup@block@colors
\fi
```

### Step 5: Update Tests

After adding the option, regenerate test expectations:

```bash
l3build-wrapped check    # Run tests (will likely fail)
l3build-wrapped save <testname>  # Update failing test expectations
l3build-wrapped check    # Verify all pass
```

## Setup Functions

Some color changes require calling setup functions to update dependent colors:

### `\moloch@setup@text@colors`

Updates colors that derive from `normal text`:
- titlelike, author, date, institute, structure, thanks

**Call when:** Setting `normal text` foreground or background

### `\moloch@setup@block@colors`

Updates block title colors that derive from `normal text`:
- block title, block title alerted, block title example

**Call when:** Setting `normal text` foreground

### `\moloch@setup@progressbar@parents`

Updates colors that derive from `progress bar`:
- title separator, progress bar in head/foot, progress bar in section page

**Call when:** Setting `progress bar` foreground or background

## Existing Color Options

Current customizable colors (use these as reference):

| Option Name | Beamer Color | Properties | Setup Functions |
|-------------|--------------|------------|-----------------|
| `alerted text` | alerted text, block title alerted | fg | Sets foreground for both |
| `example text` | example text, block title example | fg | Sets foreground for both |
| `progressbar fg` | progress bar | fg | `\moloch@setup@progressbar@parents` |
| `progressbar bg` | progress bar | bg | `\moloch@setup@progressbar@parents` |
| `normal text fg` | normal text | fg | `\moloch@setup@text@colors`, `\moloch@setup@block@colors` |
| `normal text bg` | normal text | bg | none |
| `frametitle fg` | frametitle | fg | none |
| `frametitle bg` | frametitle | bg | none |
| `standout fg` | standout | fg | none |
| `standout bg` | standout | bg | none |

## Common Patterns

### Single property color

For colors with a single customizable property (like foreground only). These typically set the foreground for both inline text and related block titles:

```tex
<color name>/.code={...},
light/<color name>/.code={...},
dark/<color name>/.code={...},
```

Examples: `alerted text`, `example text`

### Multiple property color (standard pattern)

For colors with multiple properties (fg and bg):

```tex
<color name> fg/.code={...},
light/<color name> fg/.code={...},
dark/<color name> fg/.code={...},
<color name> bg/.code={...},
light/<color name> bg/.code={...},
dark/<color name> bg/.code={...},
```

Examples: `normal text fg/bg`, `frametitle fg/bg`, `standout fg/bg`, `progressbar fg/bg`

## Testing Your Changes

1. Build the theme: `l3build unpack`
2. Run tests: `l3build-wrapped check`
3. If tests fail due to intentional changes: `l3build-wrapped save <testname>`
4. Create a test presentation using `\molochcolors{<new option>={<color>}}`
5. Test variant switching: Switch between light/dark and verify colors persist

## Tips

- **Always use full Beamer color names** in option names (not abbreviations)
- **Storage macro names use `@` instead of spaces** (`normal@text@fg` not `normal text fg`)
- **Check if setup functions are needed** by examining what the Beamer color affects
- **Test both variants** - many bugs only appear when switching variants
- **Update all test expectations** after changes to avoid CI failures
