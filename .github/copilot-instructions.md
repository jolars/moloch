# Moloch Repository - Copilot Agent Instructions

## Repository Overview

Moloch is a LaTeX Beamer presentation theme package. It is a minimalistic fork of the Metropolis theme, distributed via CTAN (Comprehensive TeX Archive Network). The repository consists of:

- **Type**: LaTeX package (Beamer theme)
- **Languages**: LaTeX (TeX), Lua (build scripts), JavaScript (release automation)
- **Build System**: l3build (LaTeX build tool)
- **Development Environment**: Nix flakes (reproducible builds)
- **Size**: Small (~10 source files, focused package)
- **Version**: Currently 1.1.0 (uses semantic versioning)

## Active Development Plans

**Color System Redesign** (In Progress): A major redesign of the color system is planned to provide granular color customization and easier theme switching. See `docs/color-redesign-plan.md` for the complete design specification. This redesign aims to maintain full backwards compatibility while adding new capabilities.

## Critical Build Requirements

### Environment Setup

**IMPORTANT**: This project requires Nix for building and testing. The LaTeX environment is managed through Nix flakes. Do NOT attempt to use system LaTeX tools directly.

1. **Nix + direnv**: If Nix is available, assume direnv is also available and will auto-load the development environment
2. **l3build vs l3build-wrapped**:
   - **Use `l3build-wrapped`** for: `doc`, `check`, and `save` commands only
   - **Use `l3build`** for: all other commands (`install`, `clean`, `unpack`, `ctan`, etc.)
3. **Never use system l3build**: The repository provides l3build through Nix

### Required Commands Format

**With direnv (preferred)**:
```bash
l3build-wrapped doc     # Documentation generation only
l3build-wrapped check   # Testing only
l3build-wrapped save    # Update test expectations
l3build <subcommand>    # All other commands (install, clean, ctan, etc.)
```

**Without direnv**:
```bash
nix develop --command l3build-wrapped doc
nix develop --command l3build-wrapped check
nix develop --command l3build-wrapped save
nix develop --command l3build <subcommand>
```

**Note**: The rest of this document uses the direnv format for brevity. If direnv is not available, prefix commands with `nix develop --command`.

## Build, Test, and Validation Steps

### Documentation Generation

The documentation system uses a multi-stage pipeline:

1. **Extract DTX documentation to Markdown** (optional - only needed after changing `.dtx` files):

   ```bash
   texlua scripts/extract-dtx-docs.lua
   ```

   - Extracts implementation docs from `src/*.dtx` files
   - Generates markdown files in `docs/implementation/`
   - Uses `scripts/convert-filter.lua` for Pandoc conversion

2. **Build Quarto book** (required after editing `docs/index.md` or DTX changes):

   ```bash
   cd docs && quarto render --to pdf
   # Or using task: task build-manual
   ```

   - Converts markdown to LaTeX (`docs/moloch.tex`)
   - Generates PDF to `docs/_site/moloch.pdf`
   - **Time**: ~60-90 seconds

3. **Documentation build complete**:

   - Generates PDF to `docs/_site/moloch.pdf`
   - **Time**: ~60-90 seconds
   - **Notes**: This is the final documentation output

**Full pipeline shortcut**:

```bash
task build-manual  # Runs step 2 automatically
```

**IMPORTANT**: When editing documentation content, edit `docs/index.md`, not `docs/moloch.tex`. That is a generated file.

## Documentation Standards

### Two Types of Documentation

The Moloch package maintains two distinct types of documentation:

#### 1. Implementation Documentation (DTX Files)

**Location**: `src/*.dtx` files  
**Audience**: Developers and advanced users  
**Style**: Literate programming

Implementation docs are embedded in the `.dtx` source files using LaTeX-style comments with the `macrocode` and `macro` environments:

```latex
% \begin{macro}{\somecommand}
%    Description of what this macro does and why it exists.
%    This is like an annotated journal of the implementation.
%    \begin{macrocode}
\newcommand{\somecommand}{%
  % actual code here
}
%    \end{macrocode}
% \end{macro}
```

**Key characteristics**:
- Describes implementation details (what and why)
- Uses LaTeX syntax in special comments
- Extracted automatically to `docs/implementation/*.md`
- Compiled into the technical documentation section of the manual

#### 2. User-Facing Documentation (Markdown Files)

**Location**: `docs/*.md` files (especially `docs/customization.md`)  
**Audience**: End users of the theme  
**Style**: User guide with examples

User docs are written in Quarto-flavored Markdown and describe how to use the theme.

**Documenting Options**: Use special fenced divs with the `describe-option` class:

```markdown
::: {.describe-option option-name="<name>" values="<val1>, <val2>" default="<default>"}

A clear description of what this option does, written for end users.

:::
```

**Example**:
```markdown
::: {.describe-option option-name="block" values="transparent, fill" default="transparent"}

Optionally adds a light grey background to block environments like `theorem` and
`example`.

:::
```

**Documenting Keys with Arbitrary Values**: For keys that accept arbitrary values
(like colors, dimensions, or strings) rather than fixed choices, use the
`describe-key` class:

```markdown
::: {.describe-key key-name="<name>" type="<type>" default="<default>"}

A clear description of what this key does, written for end users.

:::
```

**Example**:
```markdown
::: {.describe-key key-name="alerted text" type="<color>" default="theme-dependent"}

Sets the foreground color for alerted text and alerted block titles.

:::
```

Common type values: `<color>`, `<length>`, `<dimension>`, `<number>`, `<string>`

**Adding Examples**: Place example code in fenced code blocks with the `latex` language identifier. If visual output would be helpful, create a corresponding example file:

1. **In documentation** (`docs/customization.md`):
```markdown
\```latex
\documentclass{beamer}
\usetheme[background=dark]{moloch}

\begin{document}
\begin{frame}
  \frametitle{Background Color}
  This slide uses the \texttt{background=dark} option.
\end{frame}
\end{document}
\```

![Example of the "background" option.](./images/example-background.png){.lightbox}
```

2. **Create example file** (`examples/background.tex`):
```latex
\documentclass{beamer}
\usetheme[background=dark]{moloch}

\begin{document}
\begin{frame}
  \frametitle{Background Color}
  This slide uses the \texttt{background=dark} option.
\end{frame}
\end{document}
```

3. **Generate image** using the task runner:
```bash
task generate-example-images
```

This compiles all `.tex` files in `examples/` to PDF and converts them to PNG grid images in `docs/images/`.

**Image naming convention**: `example-<basename>.png` where `<basename>` is the `.tex` filename without extension.

### Documentation Workflow

When adding or changing a user-facing option:

1. **Update DTX file** (`src/*.dtx`) - Add/modify implementation with literate programming comments
2. **Document in markdown** (`docs/customization.md`) - Add a `describe-option` div
3. **Add example** (optional but recommended):
   - Create `examples/<name>.tex` with a minimal example
   - Run `task generate-example-images`
   - Reference the generated image in the markdown: `![Description](./images/example-<name>.png){.lightbox}`
4. **Rebuild documentation**:
   ```bash
   task build-manual  # Extracts DTX docs + builds Quarto book
   ```

### Important Documentation Notes

- **Never edit** `docs/moloch.tex` or `docs/Moloch.tex` - these are generated files
- **Edit** `docs/index.md` and `docs/*.md` files for user documentation
- **Use describe-option divs** for all theme options - this creates consistent formatting
- **Keep examples minimal** - show only what's needed to demonstrate the feature
- **Use lightbox images** - add `{.lightbox}` after image references for click-to-zoom
- **Extract DTX changes**: Run `task extract-dtx-docs` or `texlua scripts/extract-dtx-docs.lua` after modifying `.dtx` files

### Testing

Run the package test suite:

```bash
l3build-wrapped check  # Use l3build-wrapped for testing
```

**Time**: ~60-90 seconds  
**What it tests**: Compiles test files (`.lvt`) and compares output with expected results (`.tlg`)  
**Test files location**: `testfiles/` directory  
**Test types**:

- `test.lvt` - Main theme functionality test
- `sectionpages.lvt` - Section page rendering
- `separation.lvt` - Element separation
- `standoutnumbering.lvt` - Special frame numbering

**IMPORTANT**: All tests must pass before submitting changes. Test failures indicate broken functionality.

### Building for CTAN Distribution

Create a CTAN-ready package:

```bash
l3build ctan -q -H --show-log-on-error
```

**Time**: ~90-120 seconds  
**Output**: Creates `moloch-ctan.zip` in project root  
**Flags**:

- `-q`: Quiet mode (less output)
- `-H`: Halt on error
- `--show-log-on-error`: Display build logs if errors occur

**This is the command used in CI**. Always run this before finalizing changes.

### Installing Locally (Testing)

To test the theme locally with LaTeX:

```bash
l3build install
```

**Notes**: Installs to local texmf tree for testing

### Cleaning Build Artifacts

Remove all generated files:

```bash
l3build clean
```

## Repository Structure

### Key Directories and Files

#### Root Directory

- `build.lua` - l3build configuration (package metadata, version, test settings)
- `flake.nix` - Nix flake definition (development environment)
- `flake.lock` - Locked Nix dependencies
- `.envrc` - direnv configuration (auto-loads Nix environment)
- `Taskfile.yml` - Task runner configuration (documentation build helpers)
- `scripts/extract-dtx-docs.lua` - Script to extract docs from DTX to markdown
- `convert-filter.lua` - Pandoc Lua filter for DTX → markdown conversion
- `package.json` - Node.js dependencies for semantic-release
- `release.config.js` - Semantic release configuration
- `README.md` - User-facing documentation
- `CHANGELOG.md` - Auto-generated version history
- `LICENSE` - Creative Commons BY-SA 4.0

#### Source Files (`src/`)

Contains the theme implementation in documented LaTeX (`.dtx`) format:

- `beamerthememoloch.dtx` - Main theme file (loads sub-themes)
- `beamerthememoloch.ins` - Extraction script (generates `.sty` files)
- `beamerinnerthememoloch.dtx` - Inner theme (frames, title page, lists)
- `beamerouterthememoloch.dtx` - Outer theme (headers, footers, frame titles)
- `beamerfontthememoloch.dtx` - Font theme definitions
- `beamercolorthememoloch.dtx` - Default color theme
- `beamercolorthememoloch-tomorrow.dtx` - Alternative "tomorrow" colors
- `beamercolorthememoloch-highcontrast.dtx` - High contrast variant

**Important**: Edit `.dtx` files, not `.sty` files. The `.sty` files are generated during build and are git-ignored.

#### Documentation (`docs/`)

- `index.md` - Main manual content (Quarto markdown format)
- `_quarto.yml` - Quarto book configuration
- `implementation/` - Generated markdown from DTX files
- `Moloch.tex`, `moloch.tex` - Generated LaTeX files (intermediate, kept in git)
- `_site/` - Built website/PDF output (git-ignored)

#### Test Files (`testfiles/`)

- `*.lvt` - LaTeX test files (inputs)
- `*.tlg` - Test logs (expected outputs for regression testing)
- `support/` - Shared test fixtures

#### Examples (`examples/`)

- `demo/` - Full demonstration presentation
- `colortheme-tomorrow/` - Tomorrow theme example

### Generated/Ignored Files

Do NOT commit these (already in .gitignore):

- `*.sty` - Generated style files
- `build/` - Build directory
- `docs/_site/` - Generated documentation site
- `*-ctan.zip` - Distribution archives
- `node_modules/` - Node.js dependencies
- `.direnv/` - Direnv cache
- All standard LaTeX auxiliary files (`.aux`, `.log`, `.out`, etc.)

## GitHub Actions Workflows

### build-and-test.yml (Primary CI)

Runs on: Pull requests and pushes to `main`

Steps:

1. Checkout repository
2. Install Nix
3. Run CTAN build: `nix develop --command l3build-wrapped ctan -q -H --show-log-on-error`

**To replicate CI locally**: Run the CTAN build command. If it succeeds, CI will pass.

### release.yml (Release Workflow)

Triggered: Manual workflow dispatch only

Process:

1. Runs build-and-test workflow first
2. If tests pass, runs semantic-release to:
   - Analyze commits (conventional commits format)
   - Determine next version number
   - Update version in multiple files
   - Generate CHANGELOG.md
   - Create GitHub release
   - Commit version changes back to main

**Version Update Locations** (handled by semantic-release):

- `build.lua` - `version = "x.y.z"`
- All `src/*.dtx` files - `\ProvidesPackage` with date and version

## Common Development Workflows

### Making a Code Change

1. **Understand the change location**:
   - Theme functionality → Edit appropriate `src/*.dtx` file
   - Documentation → Edit `doc/moloch.tex`
   - Build configuration → Edit `build.lua`
   - Tests → Add/modify files in `testfiles/`

2. **Make the change**: Edit the `.dtx` file, preserving the documented source format

3. **Build and test immediately**:

   ```bash
   l3build-wrapped doc    # Use l3build-wrapped for doc
   l3build-wrapped check  # Use l3build-wrapped for check
   ```

4. **Test CTAN build**:

   ```bash
   l3build ctan -q -H --show-log-on-error
   ```

5. **Review the generated output** (if applicable):
   - View `docs/_site/moloch.pdf` for documentation changes
   - Install locally and test with example presentations for theme changes

### Updating Documentation

When changing user-facing manual content:

1. Edit `docs/index.md` (main content) or `docs/implementation/*.md` (if changing DTX structure)
2. Run full build pipeline: `task build-manual`
3. Verify output: Check `docs/_site/moloch.pdf`

When changing DTX files (code + inline documentation):

1. Edit the `.dtx` file in `src/`
2. Extract docs: `texlua scripts/extract-dtx-docs.lua` (or `task docs`)
3. Rebuild manual: `task build-manual`

### Updating Tests

When changing theme behavior:

1. Make the code change in `src/*.dtx`
2. Run tests: `l3build-wrapped check`
3. If tests fail due to intentional output changes:
   ```bash
   l3build save <testname>
   ```
   This updates the `.tlg` file with the new expected output
4. Verify tests now pass
5. Commit both the source change and updated `.tlg` file

### Adding a New Test

1. Create `testfiles/newtest.lvt` with test LaTeX code
2. Run: `nix develop --command l3build-wrapped save newtest`
3. This generates `testfiles/newtest.tlg` with expected output
4. Verify: `nix develop --command l3build-wrapped check`

## Version Management and Commits

### Commit Message Format

**CRITICAL**: Always use conventional commits format:

```
<type>(<optional scope>): <description>

[optional body]

[optional footer]
```

**Types**:

- `feat:` - New feature (triggers minor version bump)
- `fix:` - Bug fix (triggers patch version bump)
- `docs:` - Documentation only changes
- `chore:` - Maintenance (e.g., dependencies, build config)
- `test:` - Test-only changes
- `refactor:` - Code refactoring without behavior change

**Breaking changes**: Add `!` after type or `BREAKING CHANGE:` in footer for major version bump

**Examples**:

```
feat: add support for custom frame numbering format
fix: correct spacing in title page with long titles
docs: clarify installation instructions in README
test: add regression test for standout frame numbering
```

### Version Numbers

Stored in two locations (kept in sync by semantic-release):

1. `build.lua` - Line with `version = "x.y.z"`
2. All `src/*.dtx` files - In `\ProvidesPackage{...}[date vx.y.z ...]` line

**Do NOT manually edit version numbers**. Let semantic-release handle it.

## Troubleshooting and Common Issues

### "l3build: command not found"

**Cause**: Trying to run l3build without Nix environment loaded  
**Solution**: 
- **With direnv**: Ensure you're in the project directory (direnv should auto-load)
- **Without direnv**: Use `nix develop --command l3build <command>` (or `l3build-wrapped` for `doc`/`check`)

### "Cannot find file beamerthememoloch.sty"

**Cause**: Trying to compile examples without building the package first  
**Solution**:

```bash
l3build unpack
```

This generates `.sty` files from `.dtx` sources

### Test Failures After Theme Changes

**Cause**: Output changed but `.tlg` files not updated  
**Solution**: If changes are intentional:

```bash
l3build-wrapped save <testname>
```

### CI Passes But Manual Build Fails

**Cause**: Usually Nix cache/environment mismatch  
**Solution**: Clean and rebuild:

```bash
l3build clean
nix flake update
l3build ctan -q -H --show-log-on-error
```

### Nix Not Available in Environment

**Cause**: Running in environment without Nix  
**Solution**: The GitHub Actions workflow uses `cachix/install-nix-action@v27`. If testing outside CI, install Nix first or note that this is a Nix-only repository.

## Important Constraints and Guidelines

1. **Trust these instructions**: Only search for additional information if these instructions are incomplete or incorrect. The build process is fully documented above.

2. **Never skip tests**: Always run `l3build-wrapped check` after code changes. Test failures indicate broken functionality.

3. **Do not modify generated files**: The `.sty` files in `src/` after running `unpack` are generated. Edit `.dtx` files instead.

4. **Maintain documentation format**: The `.dtx` format interleaves documentation and code. Preserve the structure when editing.

5. **Minimal changes philosophy**: This theme values simplicity. Avoid adding complexity or features that can be achieved through standard Beamer interfaces.

6. **License awareness**: Code is CC-BY-SA 4.0. Derivative works must maintain attribution and same license.

7. **Test all changes with CTAN build**: The `ctan` command is the definitive build test. If it fails, CI will fail.

8. **Node.js dependencies**: Only needed for releases. Run `npm clean-install` if working with semantic-release configuration.

## Task Runner (Taskfile.yml)

The repository includes a Taskfile for common operations. Requires [Task](https://taskfile.dev/) or use commands directly:

```bash
task install        # Install theme locally (l3build install)
task docs          # Extract DTX docs to markdown (texlua extract-dtx-docs.lua)
task preview-docs  # Preview docs website (quarto preview)
task build-manual  # Build complete manual pipeline (quarto + copy to doc/)
```

## Quick Reference Command Summary

```bash
# Most common workflow - validate changes (assumes direnv is active)
task build-manual          # Build complete documentation
l3build-wrapped check      # Run all tests (use l3build-wrapped for check)
l3build ctan -q -H --show-log-on-error  # CI build

# Documentation workflow
texlua scripts/extract-dtx-docs.lua   # Extract DTX → markdown (when .dtx changes)
cd docs && quarto render --to pdf     # Build Quarto book
l3build-wrapped doc                   # Generate DTX documentation (use l3build-wrapped)

# Development helpers
l3build unpack    # Generate .sty files for testing
l3build install   # Install locally
l3build clean     # Remove build artifacts

# Test management
l3build-wrapped save <testname>  # Update test expectations

# Without direnv (prefix all commands)
nix develop --command l3build-wrapped doc    # Only for doc
nix develop --command l3build-wrapped check  # Only for check
nix develop --command l3build-wrapped save   # Only for save
nix develop --command l3build <subcommand>   # For everything else
```

## When to Search Further

Search or ask for help if:

- You encounter an error not covered in troubleshooting
- You need to understand the LaTeX Beamer theme API beyond what's in existing code
- The build.lua configuration needs options not documented here
- You're implementing a feature requiring LaTeX packages not currently used

Otherwise, trust these instructions and proceed with development.
