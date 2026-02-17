# Changelog

## [2.2.0](https://github.com/jolars/moloch/compare/v2.1.0...v2.2.0) (2026-02-17)

### Features

- increase margin between frame title and subtitle
  ([f8e8725](https://github.com/jolars/moloch/commit/f8e8725c7ed7e82af7fcaff36bb5cbffa72e5767))
- increase top-bottom margins for frametitle, use strut
  ([f537931](https://github.com/jolars/moloch/commit/f537931efd0afedae8612183c53e9686200c34bf))

### Bug Fixes

- add missing color option for title separator
  ([1221aed](https://github.com/jolars/moloch/commit/1221aed83073d8f4b39c8ec2d3449cd5718079d4)),
  closes [#70](https://github.com/jolars/moloch/issues/70)

## [2.1.0](https://github.com/jolars/moloch/compare/v2.0.0...v2.1.0) (2025-12-18)

### Features

- add `titlepage` option with moloch, plain, slit styles
  ([505426d](https://github.com/jolars/moloch/commit/505426d67719f29fafba3a2c9a7a7a0ea743308f))

### Bug Fixes

- alias `colortheme variant` to `colorthemevariant`
  ([70a2bf2](https://github.com/jolars/moloch/commit/70a2bf23d3afd90d612f82048b38f37dfe85fa79))
- don't expose all colortheme settings as package options
  ([4827f60](https://github.com/jolars/moloch/commit/4827f603f91574c7a7855d74a51d90c8de13abaf))
- don't wrap titlepage frame in group
  ([b6be996](https://github.com/jolars/moloch/commit/b6be99698abf39d513388615a9508c3b78568b29))

## [2.0.0](https://github.com/jolars/moloch/compare/v1.1.0...v2.0.0) (2025-12-05)

### ⚠ BREAKING CHANGES

- refactor color theme

### Features

- add `frametitle margin` options
  ([bc02e8a](https://github.com/jolars/moloch/commit/bc02e8a31472ef8b15ad9c043a8a9829d01d1189))
- add catppuccin theme
  ([3452624](https://github.com/jolars/moloch/commit/3452624b6406a05a1f6e0022413dff8ad3826527))
- add new "Paper" color theme
  ([05de59a](https://github.com/jolars/moloch/commit/05de59a0e2fe0a444abd72dc69e452695bac789e))
- change default progressbar linewidth to 1pt
  ([3b71fc9](https://github.com/jolars/moloch/commit/3b71fc99e4c1af6daaf5782eb663f702d3adc233))
- draw all itemize symbols manually
  ([a82527c](https://github.com/jolars/moloch/commit/a82527c6f46a4dce49e90f8d5a059b7f8e98ce29))
- refactor color theme
  ([37d3a37](https://github.com/jolars/moloch/commit/37d3a373b20b3e1c2aab8447b2341c64be907549))
- tune color themes
  ([a11710f](https://github.com/jolars/moloch/commit/a11710f1ca5fe7032861944e37268ac1417ba10a))
- use brighter aler and example colors in dark hcontr
  ([8babd1e](https://github.com/jolars/moloch/commit/8babd1e421875a79e5f4fd3b0e49faabd76f68bc))

### Bug Fixes

- enable background macro for alternative color themes
  ([59b4d79](https://github.com/jolars/moloch/commit/59b4d79ccc088ea13249aafefa12bb88cf6cb89e))
- remove and fix examples
  ([35523ee](https://github.com/jolars/moloch/commit/35523ee6a2c625c96f3f13ea68691772788efd57))
- remove example text bg in highcontrast theme
  ([528ea8d](https://github.com/jolars/moloch/commit/528ea8d424c2ae485103240d4d4899fb194c5a7c))
- work-around division by zero in progress bar arithmetic
  ([28fc1a2](https://github.com/jolars/moloch/commit/28fc1a28ca2b92376b4b87a33ab73e32c2dc959f))

## [1.1.0](https://github.com/jolars/moloch/compare/v1.0.1...v1.1.0) (2025-09-25)

### Features

- redesign itemize environment
  ([#50](https://github.com/jolars/moloch/issues/50))
  ([8594369](https://github.com/jolars/moloch/commit/859436931609930b847e5002e2ef2482d055e4de))
- use beamer-like itemize item and subitem templates
  ([81037c6](https://github.com/jolars/moloch/commit/81037c66e1a99deb0295d40a2f205a8e757ccb6b)),
  closes [#49](https://github.com/jolars/moloch/issues/49)

### Bug Fixes

- move command substitutions into inner and outer themes
  ([fd86a30](https://github.com/jolars/moloch/commit/fd86a305e954e6597fa5bc0f4be4686525b34834)),
  closes [#47](https://github.com/jolars/moloch/issues/47)
- use `\ht\strutbox` instead of X height in title padding
  ([93792f2](https://github.com/jolars/moloch/commit/93792f2cf39939a5678f34ad8c12659340969517)),
  closes [#54](https://github.com/jolars/moloch/issues/54)

## [1.0.1](https://github.com/jolars/moloch/compare/v1.0.0...v1.0.1) (2025-04-01)

### Bug Fixes

- add missing files for updating version tags
  ([ba01d33](https://github.com/jolars/moloch/commit/ba01d33b1993d4992372420f25f6390c5e4baa91))
- use proper package names
  ([0c4d38e](https://github.com/jolars/moloch/commit/0c4d38e3c2e2b0b93bfc1b6c1abe6bf0a3a01311))

## [1.0.0](https://github.com/jolars/moloch/compare/v0.6.0...v1.0.0) (2025-04-01)

### Features

- add customization of bar line width
  ([#42](https://github.com/jolars/moloch/issues/42))
  ([be0d8f2](https://github.com/jolars/moloch/commit/be0d8f23c72b9760baeb31a58d2e9988cba5d19a))
- support `\thanks` in title page
  ([#45](https://github.com/jolars/moloch/issues/45))
  ([de3db5e](https://github.com/jolars/moloch/commit/de3db5e517c06d1b8793b3a1c134b9bf4ad8b189))

## [0.6.0](https://github.com/jolars/moloch/compare/v0.5.0...v0.6.0) (2025-01-17)

### Features

- add back highcontrast theme from metropolis
  ([3039994](https://github.com/jolars/moloch/commit/3039994e27a01d54d7a3cfa696318413161f5e15))
- add new color theme based on the tomorrow color theme
  ([13e7300](https://github.com/jolars/moloch/commit/13e73007c6d29989684aa228f7f74d3bdcce526f))
- add option to customize frame numbering of standout pages
  ([d6d0e3c](https://github.com/jolars/moloch/commit/d6d0e3c61565f06d1987c275e2460c9b61ef8ae3)),
  closes [#33](https://github.com/jolars/moloch/issues/33)
- deprecate `\mreducelistspacing`
  ([3d87ec2](https://github.com/jolars/moloch/commit/3d87ec2d8d4a81c09d13083aa61af2a36ce6dd1d))
- redesign section and subsection pages
  ([#30](https://github.com/jolars/moloch/issues/30))
  ([5a98c69](https://github.com/jolars/moloch/commit/5a98c69a3f07b5b36d5d2c5e5a117e25c472ad22))
- use golden rule in top-bottom spacing of title page
  ([85eabc7](https://github.com/jolars/moloch/commit/85eabc7beef4296dcc7a7ac53eb0f7a785fe8c35))

### Reverts

- "feat: deprecate `\mreducelistspacing`"
  ([eb4bf54](https://github.com/jolars/moloch/commit/eb4bf54e734a64936903d18dbb6d1668d769fa01))
- "test: remove standoutnumbering test"
  ([ce7540d](https://github.com/jolars/moloch/commit/ce7540d71caf490cbd3129345cd778b1519394d9))

## [0.5.0](https://github.com/jolars/moloch/compare/v0.4.0...v0.5.0) (2024-10-30)

### Features

- replace `\vfill` with `\vfil` in title frame
  ([8f2a59e](https://github.com/jolars/moloch/commit/8f2a59e239cf0ae32f1a5c8fbf6ad739fa1cd328))
- switch from fill to fil ([#21](https://github.com/jolars/moloch/issues/21))
  ([873ae15](https://github.com/jolars/moloch/commit/873ae154824ed10d45f05c6efe4c4cc73eca1a22))

### Bug Fixes

- remove duplicated footnote color specifications
  ([#26](https://github.com/jolars/moloch/issues/26))
  ([1306af5](https://github.com/jolars/moloch/commit/1306af5a73e0a030ece2ad9825496cc28507ad54))
- remove extra space below progressbar section pages
  ([#27](https://github.com/jolars/moloch/issues/27))
  ([e5be480](https://github.com/jolars/moloch/commit/e5be4806ab9b975be8e8f67434c80fd2155e30b2))
- set use=block title in block body for fill
  ([e8921a6](https://github.com/jolars/moloch/commit/e8921a69642166ef22b9b27cd3633a735c22f153)),
  closes [#28](https://github.com/jolars/moloch/issues/28)
- tag files with date
  ([28003e7](https://github.com/jolars/moloch/commit/28003e7502ce420a0e24b96e27ba3d30b9b0ecbc))

## [0.4.0](https://github.com/jolars/moloch/compare/v0.3.0...v0.4.0) (2024-07-09)

### Features

- add a small amount of vertical space before subtitle
  ([b224a9b](https://github.com/jolars/moloch/commit/b224a9b5067187e64a7669b61aee029447535729))
- support memoize package (closes
  [#16](https://github.com/jolars/moloch/issues/16))
  ([1ca26e8](https://github.com/jolars/moloch/commit/1ca26e857a331fcb29296c4987b69aea0db90fae))
- support title format modifications
  ([#18](https://github.com/jolars/moloch/issues/18))
  ([46a4f49](https://github.com/jolars/moloch/commit/46a4f49e8bb95798c2d6f3b69a1b96128d95cb8b))

### Bug Fixes

- add % at the end of some commands
  ([33b9833](https://github.com/jolars/moloch/commit/33b9833f21d3e0654fe2452d0b8ac8e8eb3a47bb))
- convert raw command in manual to text
  ([ac305e9](https://github.com/jolars/moloch/commit/ac305e9b547ce44e0573f333adc4e6684eb88b68))

## [0.3.0](https://github.com/jolars/moloch/compare/v0.2.0...v0.3.0) (2024-03-06)

### Features

- bring back the `numbering` option and deprecate it
  ([9a013e4](https://github.com/jolars/moloch/commit/9a013e4d46e1c009f058862525c4d92983c4103c))
- make `framenumber` slide numbering the default
  ([54e0fce](https://github.com/jolars/moloch/commit/54e0fce68b39a10aabf646c000ffa6656dede748))
- redesign title page
  ([9e6506e](https://github.com/jolars/moloch/commit/9e6506eccdf1a55ac88540df3bf792b88f07fc7a))
- reinstate support for `block` option
  ([bf63dcd](https://github.com/jolars/moloch/commit/bf63dcd17922277a198465485931f414a9426636))
- remove custom linespread setting
  ([6a85ef4](https://github.com/jolars/moloch/commit/6a85ef4ecd170550411cd00e65fe1e1a8d88b80b)),
  closes [#8](https://github.com/jolars/moloch/issues/8)
- remove parskip setting
  ([5477051](https://github.com/jolars/moloch/commit/54770512988927ab3c8264c7fce592cd0a4e32f8)),
  closes [#9](https://github.com/jolars/moloch/issues/9)
- support subtitles
  ([1c49957](https://github.com/jolars/moloch/commit/1c499577ea8f8aadf2403bdbd4efa603cf5a64d6))

### Bug Fixes

- apply upstream beamer fix for empty shortauthor
  ([b8b2d10](https://github.com/jolars/moloch/commit/b8b2d1090da3082a8b0370ef3411f70cc6c6fc1f))
- improve vertical centering of title slide
  ([6a14981](https://github.com/jolars/moloch/commit/6a149812409ce9072b785677fe562c5c80af22d4))
- remove extraneous line space after minipage
  ([c0b9826](https://github.com/jolars/moloch/commit/c0b98267ac70d75d69c5114e93b15722849fe712))
- remove extraneous space in frametitle continuation template
  ([66f7d83](https://github.com/jolars/moloch/commit/66f7d833a9e9e55626f38b2d3bc50303317a6b1c))
- remove font configuration for bibliography; closes
  [#5](https://github.com/jolars/moloch/issues/5)
  ([ccd19fe](https://github.com/jolars/moloch/commit/ccd19fe2dd20f40813e07c96a88700d5844b6e5d))

## [0.2.0](https://github.com/jolars/moloch/compare/v0.1.0...v0.2.0) (2024-01-23)

### ⚠ BREAKING CHANGES

- remove titleformat configuration
- use beamer's own frame numbering template

### Features

- remove titleformat configuration
  ([e19f93c](https://github.com/jolars/moloch/commit/e19f93c40a92ae28f5e7bf26cc48b68675501c89))
- use beamer's own frame numbering template
  ([01b698c](https://github.com/jolars/moloch/commit/01b698c7838d2e09057a240054c3acb3c75be8dc))

## 0.1.0 (2024-01-15)

### ⚠ BREAKING CHANGES

- remove `\plain` macro
- drop deprecated options
- remove appendix redefinition
- remove pgfplots theme
- remove high-contrast theme
- uncouple fira fonts from theme
- simplify blocks and remove blocks with background

### Features

- disable hyphenation in frame titles
  ([253234e](https://github.com/jolars/moloch/commit/253234e7b262d98e216dfadffddf29023f7af06f))
- drop deprecated options
  ([548ede8](https://github.com/jolars/moloch/commit/548ede8413f1f0d5d2b762de9798f44351b2f81b))
- group institute with author and subdue color
  ([0f3f6da](https://github.com/jolars/moloch/commit/0f3f6da5733f151368d181243d74055920074fc0))
- increase minipage width for section pages
  ([160fe58](https://github.com/jolars/moloch/commit/160fe5854e87151f7b74faf29daf9969a1ef8328))
- modify bullet symbols for itemize lists
  ([0042dcb](https://github.com/jolars/moloch/commit/0042dcb8b7caa4b4b277aaa779fd2fe62f8f2ec4))
- modify example color to teal instead of light green
  ([1a2f157](https://github.com/jolars/moloch/commit/1a2f1573dc588c8e93ba6572c109620edde2d3c8))
- remove `\plain` macro
  ([95f24ae](https://github.com/jolars/moloch/commit/95f24ae73ac72d9501de0760e48bbc0cacce797f))
- remove appendix redefinition
  ([17edfad](https://github.com/jolars/moloch/commit/17edfad5975192df7561e6404bff14ba40726d2b))
- remove high-contrast theme
  ([9932e55](https://github.com/jolars/moloch/commit/9932e55efcb3ed56e402301c8aec7a3583915dd9))
- remove pgfplots theme
  ([c2f1bef](https://github.com/jolars/moloch/commit/c2f1bef3cc7b2a4c48bf2e4f3e7c0c857a54c6fa))
- simplify blocks and remove blocks with background
  ([d5317d4](https://github.com/jolars/moloch/commit/d5317d4d05c06ac85f4cbaa7e4a17f493bc6cc32))
- uncouple fira fonts from theme
  ([f960aba](https://github.com/jolars/moloch/commit/f960aba4ee56aabad24ab232a71e6673e00dc0db))

### Bug Fixes

- avoid overflow warnings from titlepage definition
  ([c1c5b85](https://github.com/jolars/moloch/commit/c1c5b85c301e0cd54213e15de8d5c606d0336059))
- fix frametitle patchmd
  ([a302893](https://github.com/jolars/moloch/commit/a30289334007b497b24a111896cc68bcc08fbd42))
- fix progress bar in inner theme too
  ([47dcf8d](https://github.com/jolars/moloch/commit/47dcf8df1ab26024e63e1f60ea59fd83a2210a2c))
- fix reference to Knuth in demo
  ([fbfcc0b](https://github.com/jolars/moloch/commit/fbfcc0b7ad78bd3628b8f98b15f32a57aaf32d38))
- insert missing parenthesis
  ([e72eaa9](https://github.com/jolars/moloch/commit/e72eaa9af24cdb1646e1785247c6579321cf6ad5))
- metropolis -&gt; moloch
  ([24cbc04](https://github.com/jolars/moloch/commit/24cbc0497a95e2a91f81fb996a0453dfb4bcdff0))
- set maxium progressbar to 1
  ([b401410](https://github.com/jolars/moloch/commit/b4014101fec3c12a5f5960817f97234511ac1aa5))

### Reverts

- "build: use alternative texlive action"
  ([5d32f73](https://github.com/jolars/moloch/commit/5d32f73e69a178665b3bc059e8973bc394eb3a4f))
- "fix: avoid overflow warnings from titlepage definition"
  ([24c5409](https://github.com/jolars/moloch/commit/24c540998b637bd80f4318d3df603329bcade81f))

### Miscellaneous Chores

- remove newline
  ([cd97b2d](https://github.com/jolars/moloch/commit/cd97b2dcb6758f674ce173ff4c45e080d37b5374))
