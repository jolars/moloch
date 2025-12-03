# Contributing to Moloch

Thank you for your interest in contributing to Moloch! This document provides
guidelines for contributing to the project.

## Prerequisites

- Git
- LaTeX distribution (TeX Live or MiKTeX)
- [l3build](https://ctan.org/pkg/l3build) (LaTeX build tool)

**Note**: A Nix flake is available for convenience if you prefer a reproducible development environment. Simply run `nix develop` to get all dependencies automatically. When using Nix, use `l3build-wrapped` instead of `l3build` for all commands.

## Getting Started

1. Fork and clone the repository:

   ```bash
   git clone https://github.com/YOUR_USERNAME/moloch.git
   cd moloch
   ```

2. If using Nix (optional):

   ```bash
   nix develop
   ```

## Development Workflow

### Making Changes

1. **Create a feature branch**:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Edit source files**:
   - Theme code: Edit `.dtx` files in `src/` (not `.sty` files - they're
     generated)
   - Documentation: Edit `docs/index.md`
   - Tests: Add/modify `.lvt` files in `testfiles/`

3. **Build documentation**:

   ```bash
   task build-manual
   # Or manually: l3build doc
   ```

4. **Run tests**:

   ```bash
   l3build check
   ```

5. **Test CTAN build**:
   ```bash
   l3build ctan -q -H --show-log-on-error
   ```

### Updating Tests

If you intentionally change output, update the test expectations:

```bash
l3build save <testname>
```

### Documentation Changes

- User manual: Edit `docs/index.md`
- Implementation docs: Extracted from `.dtx` files via
  `texlua scripts/extract-dtx-docs.lua`

## Commit Guidelines

We use [Conventional Commits](https://www.conventionalcommits.org/) for
automated versioning:

- `feat:` - New features (minor version bump)
- `fix:` - Bug fixes (patch version bump)
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Test changes
- `chore:` - Build/tooling changes

Example:

```bash
git commit -m "feat: add new color theme option"
git commit -m "fix: correct frame title alignment"
```

## Submitting Changes

1. **Ensure all tests pass**:

   ```bash
   l3build check
   ```

2. **Push your branch**:

   ```bash
   git push origin feature/your-feature-name
   ```

3. **Open a Pull Request** on GitHub

4. **CI will run** build and test workflows automatically

## Project Structure

- `src/` - Theme implementation (`.dtx` documented sources)
- `docs/` - Documentation source (Quarto markdown) and generated outputs
- `testfiles/` - Test suite
- `examples/` - Example presentations
- `build.lua` - l3build configuration

## Getting Help

- Join the [discussions board](https://github.com/jolars/moloch/discussions) for questions and community support
- Open an [issue](https://github.com/jolars/moloch/issues) for bug reports or feature requests
- Check existing issues and discussions before creating new ones

**Note**: Moloch is a minimalistic theme. We do not reimplement functionality that's easily achievable through standard Beamer commands. Please check the Beamer documentation before requesting new features.

## License

By contributing, you agree that your contributions will be licensed under the
[Creative Commons Attribution-ShareAlike 4.0 International License](LICENSE).
