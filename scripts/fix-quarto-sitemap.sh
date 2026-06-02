#!/usr/bin/env bash
set -euo pipefail

# Quarto emits sitemap <loc> entries ending in /index.html, while pages'
# rel="canonical" tags point at the trailing-slash form. Google Search Console
# then flags the sitemap URLs as duplicates with no chosen canonical.
# Upstream bug: https://github.com/quarto-dev/quarto-cli/discussions/11398

sitemap="${QUARTO_PROJECT_OUTPUT_DIR:-_site}/sitemap.xml"

[ -f "$sitemap" ] || exit 0

sed -i 's|/index\.html</loc>|/</loc>|g' "$sitemap"
