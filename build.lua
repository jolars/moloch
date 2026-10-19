#!/usr/bin/env texlua

---@diagnostic disable: lowercase-global
module = "moloch"

sourcefiledir = "src"
docfiledir = "docs/_site"
typesetfiles = { "*.tex" }
docfiles = { "moloch.pdf" }
textfiles = { "*.md", "LICENSE" }
checkengines = { "pdftex" }
checksuppfiles = { "*.tex" }

-- The Beamer theme is tested here; the ltx-talk theme has its own config,
-- because it needs a different test directory and engine.
checkconfigs = { "build", "config-talk" }

packtdszip = false

maxprintline = 9999

uploadconfig = {
	pkg = "moloch",
	version = "2.3.1",
	author = "Johan Larsson",
	uploader = "Johan Larsson",
	license = "cc-by-sa-4",
	summary = "A Minimalist, Feature-Rich Theme for Beamer and ltx-talk",
	description = "Moloch is a minimalist, feature-rich theme for LaTeX "
		.. "presentations with a clean design and extensive customization "
		.. "options. It provides a Beamer theme, and an experimental version "
		.. "of the same design for the ltx-talk class.",
	ctanPath = "/macros/latex/contrib/beamer-contrib/themes/moloch",
	repository = "https://github.com/jolars/moloch",
	bugtracker = "https://github.com/jolars/moloch/issues",
	support = "https://github.com/jolars/moloch/discussions",
	home = "https://moloch.ink",
	topic = "presentation",
	announcement_file = "ctan_announcement.txt",
}
