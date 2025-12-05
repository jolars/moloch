---
applyTo: "src/beamercolorthememoloch.dtx"
---

# Moloch Color Theme Architecture

This document explains how the color system in `beamercolorthememoloch.dtx` works, making it easy to create new color themes and add user customization options.

## Overview

The color system has three main components:

1. **Semantic Color System** - Convention-based color naming for themes
2. **Color Theme Presets** - Define complete color schemes (default, tomorrow, paper)
3. **Variant System** - Support light/dark variants with automatic switching
4. **Granular Color Options** - Allow users to override individual colors per variant

## Key Architecture Concepts

### 1. Semantic Color System

Color themes define colors using a convention-based naming system. All themes must define these **12 semantic colors**:

| Semantic Color Name | Purpose | User-Accessible |
|---------------------|---------|-----------------|
| `mNormaltextFg` | Normal text foreground | ✅ Yes |
| `mNormaltextBg` | Normal text background | ✅ Yes |
| `mFrametitleFg` | Frame title foreground | ✅ Yes |
| `mFrametitleBg` | Frame title background | ✅ Yes |
| `mAlertFg` | Alerted text foreground | ✅ Yes |
| `mExampleFg` | Example text foreground | ✅ Yes |
| `mProgressbarFg` | Progress bar foreground | ✅ Yes |
| `mProgressbarBg` | Progress bar background | ✅ Yes |
| `mTitleseparatorFg` | Title separator foreground | ✅ Yes |
| `mStandoutFg` | Standout frame foreground | ✅ Yes |
| `mStandoutBg` | Standout frame background | ✅ Yes |
| `mFootnoteFg` | Footnote foreground | ✅ Yes |

**Why semantic colors?**
- Themes define complete, self-contained color schemes
- No state leakage between themes
- Users can reference these colors in their documents (TikZ, custom text colors, etc.)
- Standard LaTeX color commands (`\definecolor`, `\colorlet`)

### 2. Color Theme Structure

Each theme command follows this pattern:

```tex
\newcommand{\moloch@colortheme@<name>}{%
  % Register light variant
  \moloch@register@light@colors{%
    % Define all 12 semantic colors
    \definecolor{mNormaltextFg}{HTML}{23373b}%
    \colorlet{mNormaltextBg}{black!2}%
    \definecolor{mAlertFg}{HTML}{EB811B}%
    % ... define all 12 colors
    
    % Apply semantic colors to Beamer
    \moloch@apply@semantic@colors
  }%
  
  % Register dark variant
  \moloch@register@dark@colors{%
    % Redefine all 12 semantic colors (with dark values)
    \colorlet{mNormaltextFg}{black!2}%
    \definecolor{mNormaltextBg}{HTML}{23373b}%
    \definecolor{mAlertFg}{HTML}{EF9F76}%
    % ... redefine all 12 colors
    
    % Apply semantic colors to Beamer
    \moloch@apply@semantic@colors
  }%
  
  % Apply current variant after registering both
  \moloch@apply@current@variant
}
```

**Key points:**
- Both variants must define **all 12 semantic colors**
- Use `\definecolor` for HTML/RGB values or `\colorlet` for color expressions/references
- Call `\moloch@apply@semantic@colors` after defining colors
- Semantic color names are overwritten when switching variants

### 3. The Semantic Color Helper

The `\moloch@apply@semantic@colors` macro:
1. **Validates** all 12 semantic colors are defined (throws clear errors if missing)
2. **Maps** semantic colors to appropriate Beamer color elements
3. **Sets up relationships** (e.g., `palette primary` derives from `frametitle`)

**Validation:** If a theme forgets to define a semantic color, users get a helpful error:
```
! Package beamercolorthememoloch Error: Semantic color 'mAlertFg' not defined.
  Color themes must define all required semantic colors
```

### 4. Variant Tracking

A boolean flag tracks the current variant:

```tex
\newif\ifmoloch@variant@dark
\moloch@variant@darkfalse  % Default to light variant
```

### 5. Variant Registration and Switching

Two commands switch between registered variants:

```tex
\newcommand{\moloch@colors@light}{%
  \moloch@define@light@colors         % Execute registered light colors
  \moloch@setup@text@colors           % Update derived colors
  \moloch@setup@block@colors          % Update block colors
  \moloch@apply@store@light@colors    % Apply user customizations
}

\newcommand{\moloch@colors@dark}{%
  \moloch@define@dark@colors          % Execute registered dark colors
  \moloch@setup@text@colors           % Update derived colors
  \moloch@setup@block@colors          % Update block colors
  \moloch@apply@store@dark@colors     % Apply user customizations
}
```

### 6. User Customization Storage System

User color customizations (via `\molochcolors{}`) are stored separately from theme defaults, allowing them to persist across variant switches:

```tex
\moloch@store@light@<color>@<property>
\moloch@store@dark@<color>@<property>
```

Example: `\moloch@store@light@alerted@text`, `\moloch@store@dark@normal@text@fg`

### 7. Application Functions

Two functions apply stored user customizations after switching variants:

- `\moloch@apply@store@light@colors` - Apply light variant user customizations
- `\moloch@apply@store@dark@colors` - Apply dark variant user customizations

These check if each storage macro is non-empty and apply it if set.

---

## How to Create a New Color Theme

Follow these steps to add a new color theme preset (e.g., `\moloch@colortheme@mycustomtheme`):

### Step 1: Create the theme command

Add a new macro in the "Color Theme Presets" section:

```tex
\newcommand{\moloch@colortheme@mycustomtheme}{%
  % Will define light and dark variants
}
```

### Step 2: Define the light variant

Register the light variant with all 12 semantic colors:

```tex
\moloch@register@light@colors{%
  % Define semantic colors using \definecolor or \colorlet
  \definecolor{mNormaltextFg}{HTML}{333333}%
  \colorlet{mNormaltextBg}{white}%
  \definecolor{mFrametitleFg}{HTML}{ffffff}%
  \definecolor{mFrametitleBg}{HTML}{0066cc}%
  \definecolor{mAlertFg}{HTML}{cc0000}%
  \definecolor{mExampleFg}{HTML}{00aa00}%
  \colorlet{mProgressbarFg}{mAlertFg}%
  \colorlet{mProgressbarBg}{mProgressbarFg!30}%
  \colorlet{mTitleseparatorFg}{mProgressbarFg}%
  \colorlet{mStandoutFg}{mNormaltextBg}%
  \colorlet{mStandoutBg}{mNormaltextFg}%
  \colorlet{mFootnoteFg}{mNormaltextFg!80}%
  
  % Apply to Beamer colors
  \moloch@apply@semantic@colors
}%
```

**Tips for defining colors:**
- Use `\definecolor{name}{HTML}{hexcode}` for absolute colors
- Use `\definecolor{name}{RGB}{r,g,b}` for RGB values
- Use `\colorlet{name}{expression}` for derived colors (e.g., `black!2`, `mAlertFg!30`)
- Common pattern: define base colors first, then derive others using `\colorlet`

### Step 3: Define the dark variant

Register the dark variant (redefine the same 12 colors with dark-appropriate values):

```tex
\moloch@register@dark@colors{%
  % Redefine all 12 semantic colors
  \colorlet{mNormaltextFg}{white}%
  \definecolor{mNormaltextBg}{HTML}{1a1a1a}%
  \colorlet{mFrametitleFg}{mNormaltextFg}%
  \definecolor{mFrametitleBg}{HTML}{003d7a}%
  \definecolor{mAlertFg}{HTML}{ff6666}%
  \definecolor{mExampleFg}{HTML}{66ff66}%
  \colorlet{mProgressbarFg}{mAlertFg}%
  \colorlet{mProgressbarBg}{mProgressbarFg!30}%
  \colorlet{mTitleseparatorFg}{mProgressbarFg}%
  \colorlet{mStandoutFg}{mNormaltextBg}%
  \colorlet{mStandoutBg}{mFrametitleBg}%
  \colorlet{mFootnoteFg}{mNormaltextFg!80}%
  
  % Apply to Beamer colors
  \moloch@apply@semantic@colors
}%
```

### Step 4: Apply the current variant

After registering both variants, apply whichever is active:

```tex
  % Apply current variant after registering both
  \moloch@apply@current@variant
}
```

### Step 5: Complete example

```tex
\newcommand{\moloch@colortheme@mycustomtheme}{%
  \moloch@register@light@colors{%
    \definecolor{mNormaltextFg}{HTML}{333333}%
    \colorlet{mNormaltextBg}{white}%
    \definecolor{mFrametitleFg}{HTML}{ffffff}%
    \definecolor{mFrametitleBg}{HTML}{0066cc}%
    \definecolor{mAlertFg}{HTML}{cc0000}%
    \definecolor{mExampleFg}{HTML}{00aa00}%
    \colorlet{mProgressbarFg}{mAlertFg}%
    \colorlet{mProgressbarBg}{mProgressbarFg!30}%
    \colorlet{mTitleseparatorFg}{mProgressbarFg}%
    \colorlet{mStandoutFg}{mNormaltextBg}%
    \colorlet{mStandoutBg}{mNormaltextFg}%
    \colorlet{mFootnoteFg}{mNormaltextFg!80}%
    
    \moloch@apply@semantic@colors
  }%
  
  \moloch@register@dark@colors{%
    \colorlet{mNormaltextFg}{white}%
    \definecolor{mNormaltextBg}{HTML}{1a1a1a}%
    \colorlet{mFrametitleFg}{mNormaltextFg}%
    \definecolor{mFrametitleBg}{HTML}{003d7a}%
    \definecolor{mAlertFg}{HTML}{ff6666}%
    \definecolor{mExampleFg}{HTML}{66ff66}%
    \colorlet{mProgressbarFg}{mAlertFg}%
    \colorlet{mProgressbarBg}{mProgressbarFg!30}%
    \colorlet{mTitleseparatorFg}{mProgressbarFg}%
    \colorlet{mStandoutFg}{mNormaltextBg}%
    \colorlet{mStandoutBg}{mFrametitleBg}%
    \colorlet{mFootnoteFg}{mNormaltextFg!80}%
    
    \moloch@apply@semantic@colors
  }%
  
  \moloch@apply@current@variant
}
```

### Step 6: Enable the theme via pgfkeys option

Add a pgfkeys option to make the theme selectable:

```tex
\pgfkeys{
  /moloch/colortheme/.cd,
  .is choice,
  default/.code=\moloch@colortheme@default,
  tomorrow/.code=\moloch@colortheme@tomorrow,
  paper/.code=\moloch@colortheme@paper,
  mycustomtheme/.code=\moloch@colortheme@mycustomtheme,  % Add this
}
```

### Step 7: Test the theme

```bash
l3build unpack                 # Generate .sty files
l3build-wrapped check          # Run tests
```

Users can now load it with:
```latex
\usetheme[colortheme=mycustomtheme, variant=light]{moloch}
```

---

## How to Add a New User Customization Option

User customization options (used via `\molochcolors{option=value}`) allow fine-grained control beyond theme presets. Follow these steps to add a new customizable color option. We'll use `normal text fg` as an example.

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

### For new color themes:

1. Build the theme: `l3build unpack`
2. Run tests: `l3build-wrapped check`
3. If tests fail, update expectations: `l3build-wrapped save <testname>`
4. Create a test presentation and verify both light and dark variants
5. Check that semantic colors are accessible: `\textcolor{mAlertFg}{test}`

### For new customization options:

1. Build the theme: `l3build unpack`
2. Run tests: `l3build-wrapped check`
3. If tests fail due to intentional changes: `l3build-wrapped save <testname>`
4. Test the option: `\molochcolors{<new option>=<color>}`
5. Test variant switching: Switch between light/dark and verify customizations persist

## Tips

### For color theme development:

- **Define all 12 semantic colors** - validation will catch missing colors
- **Use `\colorlet` for flexibility** - works with color names, expressions, and derived colors
- **Common pattern**: Define a few base colors, derive the rest using `\colorlet`
- **Test both variants** - ensure contrast and readability in both light and dark modes
- **Make semantic colors user-accessible** - users can reference them in TikZ, text colors, etc.
- **No state leakage** - each theme is self-contained and overwrites all semantic colors

### For user customization options:

- **Always use full Beamer color names** in option names (not abbreviations)
- **Storage macro names use `@` instead of spaces** (`normal@text@fg` not `normal text fg`)
- **Check if setup functions are needed** by examining what the Beamer color affects
- **Test both variants** - many bugs only appear when switching variants
- **Update all test expectations** after changes to avoid CI failures

## Summary

**Creating themes:** Define 12 semantic colors per variant → Call `\moloch@apply@semantic@colors` → Done!

**Adding customization:** Define storage macros → Create pgfkeys options → Update application functions → Test!

The semantic color system ensures themes are self-contained, predictable, and user-friendly.
