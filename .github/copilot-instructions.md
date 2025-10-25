# Moloch Repository - Copilot Agent Instructions

## Repository Overview

Moloch is a LaTeX Beamer presentation theme package. It is a minimalistic fork of the Metropolis theme, distributed via CTAN (Comprehensive TeX Archive Network). The repository consists of:

- **Type**: LaTeX package (Beamer theme)
- **Languages**: LaTeX (TeX), Lua (build scripts), JavaScript (release automation)
- **Build System**: l3build (LaTeX build tool)
- **Development Environment**: Nix flakes (reproducible builds)
- **Size**: Small (~10 source files, focused package)
- **Version**: Currently 1.1.0 (uses semantic versioning)

## Critical Build Requirements

### Environment Setup

**IMPORTANT**: This project requires Nix for building and testing. The LaTeX environment is managed through Nix flakes. Do NOT attempt to use system LaTeX tools directly.

1. **Always use Nix**: All build and test commands MUST be run via `nix develop --command`
2. **Never use system l3build**: The repository provides `l3build-wrapped` through Nix
3. **Environment setup is automatic**: When using `nix develop`, all dependencies are loaded

### Required Commands Format

All l3build commands must be invoked as:
```bash
nix develop --command l3build-wrapped <subcommand>
```

## Build, Test, and Validation Steps

### Documentation Generation

Generate the package documentation (PDF manual):
```bash
nix develop --command l3build-wrapped doc
```

**Time**: ~30-60 seconds  
**Output**: Creates `doc/moloch.pdf`  
**Notes**: Must complete without errors before running tests

### Testing

Run the package test suite:
```bash
nix develop --command l3build-wrapped check
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
nix develop --command l3build-wrapped ctan -q -H --show-log-on-error
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
nix develop --command l3build-wrapped install
```

**Notes**: Installs to local texmf tree for testing

### Cleaning Build Artifacts

Remove all generated files:
```bash
nix develop --command l3build-wrapped clean
```

## Repository Structure

### Key Directories and Files

#### Root Directory
- `build.lua` - l3build configuration (package metadata, version, test settings)
- `flake.nix` - Nix flake definition (development environment)
- `flake.lock` - Locked Nix dependencies
- `.envrc` - direnv configuration (auto-loads Nix environment)
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

#### Documentation (`doc/`)
- `moloch.tex` - Package manual source (generates `moloch.pdf`)

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
- `doc/moloch.pdf` - Generated documentation
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
3. Run documentation generation: `nix develop --command l3build-wrapped doc`
4. Run CTAN build: `nix develop --command l3build-wrapped ctan -q -H --show-log-on-error`

**To replicate CI locally**: Run both commands in sequence. If both succeed, CI will pass.

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
- `doc/moloch.tex` - `\def\molochversion{x.y.z}`
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
   nix develop --command l3build-wrapped doc
   nix develop --command l3build-wrapped check
   ```

4. **Test CTAN build**:
   ```bash
   nix develop --command l3build-wrapped ctan -q -H --show-log-on-error
   ```

5. **Review the generated output** (if applicable):
   - View `doc/moloch.pdf` for documentation changes
   - Install locally and test with example presentations for theme changes

### Updating Tests

When changing theme behavior:

1. Make the code change in `src/*.dtx`
2. Run tests: `nix develop --command l3build-wrapped check`
3. If tests fail due to intentional output changes:
   ```bash
   nix develop --command l3build-wrapped save <testname>
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

Stored in three locations (kept in sync by semantic-release):
1. `build.lua` - Line with `version = "x.y.z"`
2. `doc/moloch.tex` - Line with `\def\molochversion{x.y.z}`
3. All `src/*.dtx` files - In `\ProvidesPackage{...}[date vx.y.z ...]` line

**Do NOT manually edit version numbers**. Let semantic-release handle it.

## Troubleshooting and Common Issues

### "l3build: command not found"

**Cause**: Trying to run l3build without Nix  
**Solution**: Always use `nix develop --command l3build-wrapped <command>`

### "Cannot find file beamerthememoloch.sty"

**Cause**: Trying to compile examples without building the package first  
**Solution**: 
```bash
nix develop --command l3build-wrapped unpack
```
This generates `.sty` files from `.dtx` sources

### Test Failures After Theme Changes

**Cause**: Output changed but `.tlg` files not updated  
**Solution**: If changes are intentional:
```bash
nix develop --command l3build-wrapped save <testname>
```

### CI Passes But Manual Build Fails

**Cause**: Usually Nix cache/environment mismatch  
**Solution**: Clean and rebuild:
```bash
nix develop --command l3build-wrapped clean
nix flake update
nix develop --command l3build-wrapped ctan -q -H --show-log-on-error
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

## Quick Reference Command Summary

```bash
# Most common workflow - validate changes
nix develop --command l3build-wrapped doc      # Generate documentation
nix develop --command l3build-wrapped check    # Run all tests
nix develop --command l3build-wrapped ctan -q -H --show-log-on-error  # CI build

# Development helpers
nix develop --command l3build-wrapped unpack   # Generate .sty files for testing
nix develop --command l3build-wrapped install  # Install locally
nix develop --command l3build-wrapped clean    # Remove build artifacts

# Test management
nix develop --command l3build-wrapped save <testname>  # Update test expectations

# Enter development shell (for multiple commands)
nix develop  # Then run l3build-wrapped commands without prefix
```

## When to Search Further

Search or ask for help if:
- You encounter an error not covered in troubleshooting
- You need to understand the LaTeX Beamer theme API beyond what's in existing code
- The build.lua configuration needs options not documented here
- You're implementing a feature requiring LaTeX packages not currently used

Otherwise, trust these instructions and proceed with development.
