# Appendix H — ltx-talk Theme

> **NOTE:**
>
> **Source file:** [`src/moloch-talk.dtx`](https://github.com/jolars/moloch/blob/main/src/moloch-talk.dtx)

## H.1 Moloch for `ltx-talk`

This package brings the Moloch design to `ltx-talk`, the experimental presentation class by Joseph Wright. Unlike Beamer, `ltx-talk` has no theme mechanism: its author states explicitly that themes are not part of the `ltx-talk` approach, and that appearance is instead adjusted through the LaTeX3 template layer. This package is therefore an ordinary package that a document loads after the class:

``` latex
\DocumentMetadata{lang=en-US,tagging=on}
\documentclass{ltx-talk}
\usepackage{moloch-talk}
```

Both the class and this package are experimental. `ltx-talk` is a 0.x release whose author warns that “changes may occur to almost all interfaces”, so this package may need to follow those changes.

## H.2 Class Guard

There is no sensible way to recover if the class is missing, and the errors that would follow (undefined templates and instances) are unhelpful, so fail early with a clear message.

``` latex
\msg_new:nnnn { moloch-talk } { wrong-class }
  { The~'moloch-talk'~package~requires~the~'ltx-talk'~class. }
  {
    Load~the~class~first:~\iow_char:N\\documentclass{ltx-talk}.~
    For~Beamer~presentations~use~\iow_char:N\\usetheme{moloch}~instead.
  }
\cs_if_exist:NF \ps@talk
  { \msg_fatal:nn { moloch-talk } { wrong-class } }
```

## H.3 Colors

The color names are the same as in the Beamer theme, so that recipes carry over between the two and the two ports stay conceptually in sync. Only the default color theme is provided; the alternative themes of the Beamer version (`tomorrow`, `catppuccin`, and so on) are not ported yet.

### H.3.1 `\__moloch_colors_light:`

The light variant, transcribed from the Beamer color theme.

``` latex
\cs_new_protected:Npn \__moloch_colors_light:
  {
    \definecolor { mNormaltextFg } { HTML } { 23373B }
    \colorlet    { mNormaltextBg } { black!2 }
    \definecolor { mAlertFg }      { HTML } { EB811B }
    \definecolor { mExampleFg }    { RGB }  { 0 , 128 , 128 }
    \colorlet    { mFrametitleFg } { mNormaltextBg }
    \colorlet    { mFrametitleBg } { mNormaltextFg }
    \colorlet    { mProgressbarFg } { mAlertFg }
    \colorlet    { mProgressbarBg } { mProgressbarFg!50!black!30 }
    \colorlet    { mTitleseparatorFg } { mProgressbarFg }
    \colorlet    { mStandoutFg }   { mNormaltextBg }
    \colorlet    { mStandoutBg }   { mNormaltextFg }
    \colorlet    { mFootnoteFg }   { mNormaltextFg!90 }
  }
```

### H.3.2 `\__moloch_colors_dark:`

The dark variant. Note that it is not simply the light variant inverted: the alert and example colors are lightened for contrast against the dark background, exactly as in the Beamer theme.

``` latex
\cs_new_protected:Npn \__moloch_colors_dark:
  {
    \colorlet    { mNormaltextFg } { black!2 }
    \definecolor { mNormaltextBg } { HTML } { 23373B }
    \definecolor { mAlertFg }      { HTML } { EF9F76 }
    \definecolor { mExampleFg }    { HTML } { 5ABFB5 }
    \colorlet    { mFrametitleFg } { mNormaltextBg }
    \colorlet    { mFrametitleBg } { black!15 }
    \colorlet    { mProgressbarFg } { mAlertFg }
    \colorlet    { mProgressbarBg } { mProgressbarFg!50!black!30 }
    \colorlet    { mTitleseparatorFg } { mProgressbarFg }
    \colorlet    { mStandoutFg }   { mNormaltextBg }
    \colorlet    { mStandoutBg }   { black!15 }
    \colorlet    { mFootnoteFg }   { mNormaltextFg!90 }
  }
```

### H.3.3 `\__moloch_colors_apply:`

The class uses three semantic colors. Mapping `structure` to the normal text color reproduces Moloch’s convention that block titles, list labels and table-of-contents entries are simply the body color in bold, rather than a separate accent color.

Selecting the body color again also updates the current color after a variant change. Redefining its name alone leaves the previously selected color active, which would make dark text disappear on a dark background. Inside a standout, both the current color and the structure color must instead follow the standout foreground to retain contrast.

``` latex
\bool_new:N \l__moloch_standout_bool
\cs_new_protected:Npn \__moloch_colors_apply:
  {
    \bool_if:NTF \l__moloch_standout_bool
      {
        \DeclareColor { structure } { mStandoutFg }
        \color_select:n { mStandoutFg }
      }
      {
        \DeclareColor { structure } { mNormaltextFg }
        \color_select:n { mNormaltextFg }
      }
    \DeclareColor { alert }     { mAlertFg }
    \DeclareColor { example }   { mExampleFg }
  }
```

## H.4 Options

The option surface is deliberately much smaller than the Beamer theme’s. Anything not covered here is adjusted with the class’s own interfaces, and .

``` latex
\tl_new:N   \l__moloch_progressbar_tl
\tl_new:N   \l__moloch_sectionpage_tl
\dim_new:N  \l__moloch_progressbar_dim
\dim_new:N  \l__moloch_titlerule_dim
\bool_new:N \l__moloch_framenumber_bool

\keys_define:nn { moloch }
  {
    variant .choice: ,
    variant / light .code:n =
      { \__moloch_colors_light: \__moloch_colors_apply: } ,
    variant / dark .code:n =
      { \__moloch_colors_dark: \__moloch_colors_apply: } ,
    progressbar .choices:nn =
      { none , head , frametitle , foot }
      { \tl_set_eq:NN \l__moloch_progressbar_tl \l_keys_choice_tl } ,
    progressbar-linewidth .dim_set:N = \l__moloch_progressbar_dim ,
    sectionpage .choices:nn =
      { none , simple , progressbar }
      { \tl_set_eq:NN \l__moloch_sectionpage_tl \l_keys_choice_tl } ,
    titleseparator-linewidth .dim_set:N = \l__moloch_titlerule_dim ,
    framenumber .bool_set:N = \l__moloch_framenumber_bool
  }
```

The defaults match the Beamer theme: no progress bar, section pages with a progress bar, a 1pt bar and a 0.5pt title separator.

``` latex
\keys_set:nn { moloch }
  {
    variant = light ,
    progressbar = none ,
    progressbar-linewidth = 1pt ,
    sectionpage = progressbar ,
    titleseparator-linewidth = 0.5pt ,
    framenumber = true
  }
\ProcessKeyOptions [ moloch ]
```

### H.4.1 `\molochset`

Options can also be set after loading. Changing variants selects the new body color. Inside a frame, the palette and page options are saved globally because the class closes the body’s typesetting groups before drawing the header, footer, and background. The frame and slide numbers limit those saved settings to the pages produced by the current body.

Nested groups must still restore their enclosing settings. The class runs its tagging setup in the box surrounding the body, immediately before opening the body’s box and color groups. Recording the depth of the inner group lets us refresh the saved settings as nested groups close, while keeping the final body settings available after the body itself closes.

``` latex
\int_new:N \l__moloch_body_group_int
\cs_new_eq:NN \__moloch_slide_tag_on_begin: \__talk_slide_tag_on_begin:
\cs_set_protected:Npn \__talk_slide_tag_on_begin:
  {
    \__moloch_slide_tag_on_begin:
    \int_set:Nn \l__moloch_body_group_int
      { \tex_currentgrouplevel:D + 2 }
  }
\cs_new_eq:NN \__moloch_slide_tag_off_begin: \__talk_slide_tag_off_begin:
\cs_set_protected:Npn \__talk_slide_tag_off_begin:
  {
    \__moloch_slide_tag_off_begin:
    \int_set:Nn \l__moloch_body_group_int
      { \tex_currentgrouplevel:D + 2 }
  }
\int_new:N \g__moloch_settings_frame_int
\int_new:N \g__moloch_settings_slide_int
\int_gset:Nn \g__moloch_settings_frame_int { -1 }
\tl_new:N \g__moloch_frame_settings_tl
\tl_new:N \l__moloch_color_spec_tl
\cs_new_protected:Npn \__moloch_frame_settings_save:
  {
    \int_gset:Nn \g__moloch_settings_frame_int { \value { frame } }
    \int_gset:Nn \g__moloch_settings_slide_int { \value { slide } }
    \tl_gset:Ne \g__moloch_frame_settings_tl
      {
        \exp_not:N \keys_set:nn { moloch }
          {
            progressbar = \exp_not:V \l__moloch_progressbar_tl ,
            progressbar-linewidth = \dim_use:N \l__moloch_progressbar_dim ,
            framenumber = \bool_if:NTF \l__moloch_framenumber_bool
              { true } { false }
          }
      }
    \clist_map_inline:nn
      {
        mNormaltextFg , mNormaltextBg , mAlertFg , mExampleFg ,
        mFrametitleFg , mFrametitleBg , mProgressbarFg , mProgressbarBg ,
        mTitleseparatorFg , mStandoutFg , mStandoutBg , mFootnoteFg ,
        structure , alert , example
      }
      {
        \extractcolorspec {##1} \l__moloch_color_spec_tl
        \tl_gput_right:Ne \g__moloch_frame_settings_tl
          { \exp_not:N \definecolor {##1} \exp_not:V \l__moloch_color_spec_tl }
      }
    \int_compare:nNnT
      { \tex_currentgrouplevel:D } > \l__moloch_body_group_int
      { \group_insert_after:N \__moloch_frame_settings_save: }
  }
\NewDocumentCommand \molochset { m }
  {
    \keys_set:nn { moloch } {#1}
    \bool_if:NT \l__talk_frame_bool { \__moloch_frame_settings_save: }
  }
```

## H.5 Frame Title Band

Moloch’s frame title sits in a band that spans the full paper width, with the title one strut height above the band’s lower edge and two above its baseline — three strut heights in total, measured in the frame title font.

The class already draws a full-width band for the running header, sized from the `geometry` package’s top margin and header separation. So rather than rebuilding the header template, the proportions are obtained by setting those two lengths: `geometry`’s `tmargin` measures from the top of the paper to the top of the body text, which is exactly the band’s visible height.

``` latex
\dim_new:N \g__moloch_band_dim
\dim_new:N \g__moloch_headsep_dim
\group_begin:
  \large
  \dim_gset:Nn \g__moloch_band_dim { 3 \ht \strutbox }
  \dim_gset:Nn \g__moloch_headsep_dim { \ht \strutbox }
\group_end:
```

The frame title also hangs closer to the edge of the paper than the body text does. This is one of the places where the class’s default differs from Moloch: it aligns the frame title with the body text instead. The measure is taken in the body font, as in the Beamer theme.

``` latex
\dim_new:N \g__moloch_hmargin_dim
\group_begin:
  \normalsize
  \dim_gset:Nn \g__moloch_hmargin_dim { 0.85 \ht \strutbox }
\group_end:
```

The footer sits lower than the class puts it, so that the frame number ends up on the same line as in the Beamer theme, whose footer leaves 4pt below the number. The distance from the bottom of the body text to the footer baseline is what `geometry` calls the foot skip.

``` latex
\dim_const:Nn \c__moloch_footer_baseline_dim { 4pt }
\dim_new:N \g__moloch_footskip_dim
\dim_gset:Nn \g__moloch_footskip_dim
  { \Gm@bmargin - \c__moloch_footer_baseline_dim }
```

The header box also has to be tall enough to hold the band, or every frame reports an overfull box while the output routine is active.

``` latex
\use:e
  {
    \exp_not:N \geometry
      {
        tmargin = \dim_use:N \g__moloch_band_dim ,
        headheight = \dim_use:N \g__moloch_band_dim ,
        headsep = \dim_use:N \g__moloch_headsep_dim ,
        footskip = \dim_use:N \g__moloch_footskip_dim
      }
  }
```

With the geometry in place only the colors and the font need changing. The header’s `height` key is left at its default, which is written in terms of the `geometry` lengths and so follows the change above.

``` latex
\EditInstance { header } { std }
  {
    background-color = mFrametitleBg ,
    color = mFrametitleFg ,
    left-hspace = \g__moloch_hmargin_dim
  }
\EditInstance { frametitle } { header }
  { font = \large \bfseries }
```

## H.6 Rules and the Progress Bar

### H.6.1 `\__moloch_rule:nnn`

A rule given as width, height and depth. The class has an equivalent helper, but it is internal to the class, so this package provides its own.

``` latex
\dim_new:N \l__moloch_rule_wd_dim
\dim_new:N \l__moloch_rule_ht_dim
\dim_new:N \l__moloch_rule_dp_dim
\cs_new_protected:Npn \__moloch_rule:nnn #1#2#3
  {
    \group_begin:
      \dim_set:Nn \l__moloch_rule_wd_dim { #1 }
      \dim_set:Nn \l__moloch_rule_dp_dim { 0pt - ( #3 ) }
      \dim_set:Nn \l__moloch_rule_ht_dim { ( #2 ) + ( #3 ) }
      \rule
        [ \l__moloch_rule_dp_dim ]
        { \l__moloch_rule_wd_dim }
        { \l__moloch_rule_ht_dim }
    \group_end:
  }
```

### H.6.2 `\__moloch_progress_frac:`

How far through the presentation we are, as a number between 0 and 1. The fallback of 100 total frames keeps the first compilation, when the total is not yet known, from producing an over-long bar; the Beamer theme uses the same guard.

``` latex
\cs_new:Npn \__moloch_progress_frac:
  {
    \fp_eval:n
      {
        min
          (
            1 ,
            \int_use:N \c@frame /
            max ( 1 , \property_ref:nnn { lastpage } { totalframes } { 100 } )
          )
      }
  }
```

### H.6.3 `\__moloch_progress_width:n`

The filled portion of a bar of the given width. The fraction cannot simply be placed in front of the width, because that is only valid when the width is a length register rather than an expression.

``` latex
\cs_new:Npn \__moloch_progress_width:n #1
  {
    \fp_to_dim:n
      { \__moloch_progress_frac: * \dim_to_fp:n { #1 } }
  }
```

### H.6.4 `\__moloch_progressbar:nn`

The bar itself, given a height and a depth relative to the current baseline. It is drawn as an overlapping box of zero width, so that it can be placed at the start of the header or footer without disturbing what follows.

Drawing the bar here, rather than in a `shipout/background` hook, is what makes it obey the page style: a background hook cannot tell a plain page from an ordinary one, and the bar would then also appear on the title page, on section pages and on standout frames.

``` latex
\cs_new_protected:Npn \__moloch_progressbar:nn #1#2
  {
    \hbox_overlap_right:n
      {
        \skip_horizontal:n { -\Gm@lmargin }
        \group_begin:
          \color_select:n { mProgressbarBg }
          \__moloch_rule:nnn { \paperwidth } {#1} {#2}
        \group_end:
        \skip_horizontal:n { -\paperwidth }
        \group_begin:
          \color_select:n { mProgressbarFg }
          \__moloch_rule:nnn
            { \__moloch_progress_width:n { \paperwidth } } {#1} {#2}
        \group_end:
      }
  }
```

### H.6.5 `\__moloch_progressbar_head:`

### H.6.6 `\__moloch_progressbar_frametitle:`

### H.6.7 `\__moloch_progressbar_foot:`

The three positions. The header baseline sits one header separation above the lower edge of the band, so a negative height places the bar exactly at that edge for the `frametitle` position. The top of the page is therefore one header separation closer to the baseline than the top margin.

``` latex
\cs_new_protected:Npn \__moloch_progressbar_head:
  {
    \__moloch_progressbar:nn
      { \Gm@tmargin - \headsep }
      { \l__moloch_progressbar_dim - \Gm@tmargin + \headsep }
  }
\cs_new_protected:Npn \__moloch_progressbar_frametitle:
  {
    \__moloch_progressbar:nn
      { -\headsep }
      { \headsep + \l__moloch_progressbar_dim }
  }
\cs_new_protected:Npn \__moloch_progressbar_foot:
  {
    \__moloch_progressbar:nn
      { \l__moloch_progressbar_dim - \Gm@bmargin + \footskip }
      { \Gm@bmargin - \footskip }
  }
```

### H.6.8 `\__moloch_progress_rule:n`

A horizontal progress bar of a given width, for use on section pages, where it is part of the text rather than part of the page furniture. It hangs below the baseline rather than sitting on it, as the Beamer theme’s does.

``` latex
\cs_new_protected:Npn \__moloch_progress_rule:n #1
  {
    \leavevmode
    \hbox_overlap_right:n
      {
        \group_begin:
          \color_select:n { mProgressbarBg }
          \__moloch_rule:nnn {#1} { 0pt } { \l__moloch_progressbar_dim }
        \group_end:
      }
    \hbox_overlap_right:n
      {
        \group_begin:
          \color_select:n { mProgressbarFg }
          \__moloch_rule:nnn
            { \__moloch_progress_width:n {#1} }
            { 0pt }
            { \l__moloch_progressbar_dim }
        \group_end:
      }
    \rule {#1} { 0pt }
  }
```

## H.7 Page Style

A separate footer instance keeps the class’s own footer available through {talk}. It uses the class’s footer elements and short metadata, but places a final frame number at the right edge without the trailing glue that the class’s footer template adds.

Both edges sit closer to the paper edge than the body text does, as in the Beamer theme. The skips outside the box keep its total width equal to the text width, so the output routine can place it normally.

``` latex
\tl_new:N \l__moloch_footer_color_tl
\tl_new:N \l__moloch_footer_font_tl
\tl_new:N \l__moloch_footer_separator_tl
\tl_new:N \l__moloch_footer_metadata_tl
\clist_new:N \l__moloch_footer_order_clist
\seq_new:N \l__moloch_footer_elements_seq
\dim_new:N \l__moloch_footer_left_dim
\dim_new:N \l__moloch_footer_right_dim
\DeclareTemplateInterface { footer } { moloch } { 0 }
  {
    color         : tokenlist = mFootnoteFg ,
    font          : tokenlist = \tiny ,
    element-order : commalist = { framenumber } ,
    left-hspace   : length = 4pt ,
    right-hspace  : length = 5pt ,
    separator     : tokenlist = \hfil
  }
\cs_new:Npn \__moloch_footer_metadata:n #1
  {
    \cs_if_exist:cTF { @ short #1 }
      { @ short #1 }
      { @ #1 }
  }
\cs_new_protected:Npn \__moloch_footer_element:n #1
  {
    \tl_set:Ne \l__moloch_footer_metadata_tl
      { \__moloch_footer_metadata:n {#1} }
    \ExpandArgs { nnv } \UseInstance { footer-element } {#1}
      { \l__moloch_footer_metadata_tl }
  }
\DeclareTemplateCode { footer } { moloch } { 0 }
  {
    color         = \l__moloch_footer_color_tl ,
    font          = \l__moloch_footer_font_tl ,
    element-order = \l__moloch_footer_order_clist ,
    left-hspace   = \l__moloch_footer_left_dim ,
    right-hspace  = \l__moloch_footer_right_dim ,
    separator     = \l__moloch_footer_separator_tl
  }
  {
    \seq_clear:N \l__moloch_footer_elements_seq
    \clist_map_inline:Nn \l__moloch_footer_order_clist
      {
        \bool_lazy_or:nnT
          { ! \str_if_eq_p:nn {##1} { framenumber } }
          { \l__moloch_framenumber_bool }
          {
            \tl_if_empty:cF { \__moloch_footer_metadata:n {##1} }
              { \seq_put_right:Nn \l__moloch_footer_elements_seq {##1} }
          }
      }
    \skip_horizontal:n { \l__moloch_footer_left_dim - \Gm@lmargin }
    \hbox_to_wd:nn
      { \paperwidth - \l__moloch_footer_left_dim - \l__moloch_footer_right_dim }
      {
        \tl_if_empty:NF \l__moloch_footer_color_tl
          { \color_select:V \l__moloch_footer_color_tl }
        \l__moloch_footer_font_tl
        \seq_map_indexed_inline:Nn \l__moloch_footer_elements_seq
          {
            \int_compare:nNnTF {##1} > { 1 }
              { \l__moloch_footer_separator_tl }
              { \str_if_eq:nnT {##2} { framenumber } { \hfil } }
            \__moloch_footer_element:n {##2}
          }
        \str_if_eq:eeF
          { \seq_item:Nn \l__moloch_footer_elements_seq { -1 } }
          { framenumber }
          { \hfil }
      }
    \skip_horizontal:n { \l__moloch_footer_right_dim - \Gm@rmargin }
  }
\DeclareInstance { footer } { moloch } { moloch } { }
```

The header is drawn in an overlapping box so that the progress bar can follow it at the same horizontal position. This keeps the header’s background from covering a bar placed at the top of the page.

``` latex
\cs_new_nopar:Npn \ps@moloch
  {
    \cs_set_nopar:Npn \@oddhead
      {
        \hbox_overlap_right:n { \UseInstance { header } { std } }
        \str_case:Vn \l__moloch_progressbar_tl
          {
            { head }       { \__moloch_progressbar_head: }
            { frametitle } { \__moloch_progressbar_frametitle: }
          }
        \hfil
      }
    \cs_set_nopar:Npn \@oddfoot
      {
        \str_if_eq:VnT \l__moloch_progressbar_tl { foot }
          { \__moloch_progressbar_foot: }
        \UseInstance { footer } { moloch }
      }
    \cs_set_eq:NN \@evenhead \@oddhead
    \cs_set_eq:NN \@evenfoot \@oddfoot
  }
\pagestyle { moloch }
```

## H.8 Lists

Draw the same circle, square, and triangle as the Beamer theme so that the markers do not depend on font glyphs. The class’s list instances use the standard label commands, which keeps explicit item labels and the class’s tagging and overlay handling intact. The fourth level retains its class default, since Beamer only supports three levels.

The circle and triangle overhang slightly to align their visible edges with the square, just as they do in the Beamer theme.

The class selects colors through the LaTeX3 color layer, while PGF reads xcolor’s current color. Export the current label color explicitly so the drawn markers also follow dark variants and custom label colors.

``` latex
\ExplSyntaxOff
\RequirePackage{pgf}
\ExplSyntaxOn

\tl_new:N \l__moloch_itemize_color_tl
\cs_new_protected:Npn \__moloch_itemize_marker:nn #1#2
  {
    \hbox_overlap_left:n
      {
        \color_export:nnN { . } { comma-sep-rgb } \l__moloch_itemize_color_tl
        \exp_args:NnnV \definecolor { molochItemizeColor } { rgb }
          \l__moloch_itemize_color_tl
        #1
      }
    \kern -#2 \scan_stop:
  }
\cs_new_protected:Npn \__moloch_itemize_circle:
  {
    \begin{pgfpicture}
      \pgfsetfillcolor { molochItemizeColor }
      \pgfsetbaseline { -0.7ex }
      \pgfpathcircle { \pgfpoint { 0 } { 0 } } { 0.16em }
      \pgfusepath { fill }
    \end{pgfpicture}
  }
\cs_new_protected:Npn \__moloch_itemize_square:
  {
    \begin{pgfpicture}
      \pgfsetfillcolor { molochItemizeColor }
      \pgfsetbaseline { -0.7ex }
      \pgfpathrectangle
        { \pgfpoint { -0.165em } { -0.165em } }
        { \pgfpoint { 0.31em } { 0.31em } }
      \pgfusepath { fill }
    \end{pgfpicture}
  }
\cs_new_protected:Npn \__moloch_itemize_triangle:
  {
    \begin{pgfpicture}
      \pgfsetfillcolor { molochItemizeColor }
      \pgfsetbaseline { -0.7ex }
      \pgfpathmoveto { \pgfpoint { 0.21em } { 0 } }
      \pgfpathlineto { \pgfpoint { -0.21em } { 0.21em } }
      \pgfpathlineto { \pgfpoint { -0.21em } { -0.21em } }
      \pgfpathclose
      \pgfusepath { fill }
    \end{pgfpicture}
  }
\cs_set_protected:Npn \labelitemi
  { \__moloch_itemize_marker:nn { \__moloch_itemize_circle: } { 0.05ex } }
\cs_set_protected:Npn \labelitemii
  { \__moloch_itemize_marker:nn { \__moloch_itemize_square: } { 0pt } }
\cs_set_protected:Npn \labelitemiii
  { \__moloch_itemize_marker:nn { \__moloch_itemize_triangle: } { 0.25ex } }
```

## H.9 Captions

The class keeps captions unnumbered. The kernel’s caption hook and label socket let us adjust their typography without replacing the code that tags the caption and its label.

``` latex
\AddToHook { cmd / @makecaption / before } { \small }
\NewSocketPlug { caption / label } { moloch }
  { \textbf {#1} :~ }
\AssignSocketPlug { caption / label } { moloch }
```

## H.10 Title Page

The class builds its title page from a list of named elements, each of which is an instance of the `titlepage-element` template, and takes the content of an element named `x` from the macro . A separator rule is therefore added by defining the content and declaring a matching instance, then naming it in the element order.

``` latex
\tl_new:c { @titleseparator }
\tl_set:cn { @titleseparator }
  { \noindent \rule { \textwidth } { \l__moloch_titlerule_dim } }
\DeclareInstance { titlepage-element } { titleseparator } { talk }
  {
    before-skip = 0.4em ,
    after-skip = 0.8em ,
    color = mTitleseparatorFg
  }
```

The remaining elements only need Moloch’s fonts and spacing.

``` latex
\EditInstance { titlepage-element } { title }
  { font = \Large \bfseries , color = mNormaltextFg }
\EditInstance { titlepage-element } { subtitle }
  { font = \large , color = mNormaltextFg , before-skip = 0.3em }
\EditInstance { titlepage-element } { author }
  { font = \small , before-skip = 0em , after-skip = 0.5em }
\EditInstance { titlepage-element } { institute }
  { font = \scriptsize , color = mNormaltextFg!80!mNormaltextBg }
\EditInstance { titlepage-element } { date }
  { font = \small , before-skip = 1em }
```

### H.10.1 `\__moloch_titlepage:n`

The `titlepage` template has no instance, so its defaults cannot be edited and has to be redefined instead.

The Beamer theme places the title block slightly above the vertical center, in golden-ratio proportion. This theme uses the class’s centered alignment instead.

``` latex
\cs_new_protected:Npn \__moloch_titlepage:n #1
  {
    \UseTemplate { titlepage } { talk }
      {
        frame-style = plain ,
        horizontal-alignment = left ,
        vertical-alignment = center ,
        element-order =
          { title , subtitle , titleseparator , author , institute , date } ,
        #1
      }
  }
```

### H.10.2 `\maketitle`

Whether the frame environment takes a mandatory title argument depends on the class option `frame-title-arg`, which is already fixed by the time this package loads. The empty group is therefore inserted at definition time, as the class itself does. Everything must sit in a single macro body, because the frame environment collects its content up to a literal {frame}.

``` latex
\use:e
  {
    \exp_not:N \RenewDocumentCommand \exp_not:N \maketitle { O { } }
      {
        \exp_not:N \bool_if:NTF \exp_not:N \l__talk_frame_bool
          { \exp_not:N \__moloch_titlepage:n { \exp_not:N #1 } }
          {
            \exp_not:N \begin { frame }
              \bool_if:NT \l__talk_frame_title_bool { { } }
              \exp_not:N \__moloch_titlepage:n { \exp_not:N #1 }
            \exp_not:N \end { frame }
          }
      }
  }
```

## H.11 Section Pages

The class emits nothing at a section heading, but does provide a hook. Note that, unlike in Beamer, a section heading inside a frame is ignored entirely by the class, so a section page can only be produced from outside a frame.

``` latex
\cs_new_protected:Npn \__moloch_section_page_body:
  {
    \thispagestyle { plain }
    \centering
    \begin { minipage } { 0.7875 \linewidth }
      \raggedright
      \color { mNormaltextFg }
      \Large \bfseries
      \insertsection
      \par
      \str_if_eq:VnT \l__moloch_sectionpage_tl { progressbar }
        {
          \skip_vertical:n { -0.5 \baselineskip }
          \__moloch_progress_rule:n { \linewidth }
        }
      % The Beamer theme always leaves a line below the bar for the
      % subsection, whether or not there is one. Keeping it means the block
      % is the same height, and so sits at the same place on the page.
      \par
      \large
      \strut
    \end { minipage }
    \par
```

A section page carries neither the frame title band nor the footer, so the block is centered on the paper rather than in the text area, which is what the Beamer theme does. The frame centers its content between equal glue, so a skip at the end moves the block up by half its size.

``` latex
    \skip_vertical:n { \Gm@tmargin - \Gm@bmargin }
  }
\use:e
  {
    \exp_not:N \cs_new_protected:Npn \exp_not:N \__moloch_section_page:
      {
        \exp_not:N \begin { frame }
          [ vertical-alignment = center ]
          \bool_if:NT \l__talk_frame_title_bool { { } }
          \exp_not:N \__moloch_section_page_body:
        \exp_not:N \end { frame }
      }
  }
\AddToHook { section / begin }
  {
    \str_if_eq:VnF \l__moloch_sectionpage_tl { none }
      { \__moloch_section_page: }
  }
```

## H.12 Standout Frames

A standout frame inverts the colors and centers a short message. The class has no per-frame appearance option, so this is a separate environment. The semantic structure color follows the standout foreground so list labels and block titles remain visible against its background.

The background cannot be set with : the class redefines that command to install a permanent background hook, so it would tint every later page as well. Instead a single hook is installed once, guarded by the frame number recorded when the standout body is typeset. The class saves this body for reused and supplementary frames, so they also record their current frame number when rendered. All slides of that frame share the same background.

``` latex
\int_new:N \g__moloch_standout_frame_int
\int_gset:Nn \g__moloch_standout_frame_int { -1 }
```

### H.12.1 `standout`

``` latex
\cs_new_protected:Npn \__moloch_standout_body:n #1
  {
    \int_gset:Nn \g__moloch_standout_frame_int { \value { frame } }
    \bool_set_true:N \l__moloch_standout_bool
    \DeclareColor { structure } { mStandoutFg }
    \color { mStandoutFg }
    \centering
    \Large \bfseries
    #1
    \par
  }
```

The frame number is recorded globally because the body is typeset in a box whose group ends before shipout. The next ordinary frame advances the counter, so the hook no longer applies to it.

``` latex
\use:e
  {
    \exp_not:N \NewDocumentEnvironment { standout }
      { !D <> { all } !O { } +b }
      {
        \exp_not:N \begin { frame } < \exp_not:N #1 >
          [ vertical-alignment = center , \exp_not:N #2 ]
          \bool_if:NT \l__talk_frame_title_bool { { } }
          \exp_not:N \__moloch_standout_body:n { \exp_not:N #3 }
        \exp_not:N \end { frame }
      }
      { }
  }
```

## H.13 Page Background and Text Color

The page-building hooks keep a frame’s saved settings active through both the page furniture and the shipout background hooks. Their extra group restores the surrounding palette, page options, and page style afterward. A standout uses the plain style on every page, including automatic frame breaks.

``` latex
\AddToHook { build / page / before }
  {
    \group_begin:
    \bool_lazy_and:nnT
      { \int_compare_p:nNn { \value { frame } } = \g__moloch_settings_frame_int }
      { \int_compare_p:nNn { \value { slide } } = \g__moloch_settings_slide_int }
      { \tl_use:N \g__moloch_frame_settings_tl }
    \int_compare:nNnT
      { \value { frame } } = \g__moloch_standout_frame_int
      { \pagestyle { plain } }
  }
\AddToHook { build / page / after } { \group_end: }
```

The page color and the default text color are set at the beginning of the document, so that a change of variant in the preamble is picked up.

Standard color resets, including those used by minipage footnotes, must retain the standout foreground while its body is being typeset.

The standout background hook is installed here too, and deliberately after the page color, so that it is applied on top of it.

``` latex
\AddToHook { begindocument }
  {
    \pagecolor { mNormaltextBg }
    \color { mNormaltextFg }
    \renewcommand \normalcolor
      {
        \bool_if:NTF \l__moloch_standout_bool
          { \color { mStandoutFg } }
          { \color { mNormaltextFg } }
      }
    \AddToHook { shipout / background }
      {
        \int_compare:nNnT
          { \value { frame } } = \g__moloch_standout_frame_int
          {
            \put ( 0cm , -\paperheight )
              {
                \group_begin:
                  \color { mStandoutBg }
                  \rule { \paperwidth } { \paperheight }
                \group_end:
              }
          }
      }
  }
```
