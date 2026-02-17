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

packtdszip = false

maxprintline = 9999

uploadconfig = {
	pkg = "moloch",
	version = "2.2.0",
	author = "Johan Larsson",
	uploader = "Johan Larsson",
	license = "cc-by-sa-4",
	summary = "A Minimalist, Feature-Rich Beamer Theme",
	description = "Moloch is a minimalist, feature-rich Beamer theme "
		.. "for LaTeX presentations with a clean design and extensive "
		.. "customization options.",
	ctanPath = "/macros/latex/contrib/beamer-contrib/themes/moloch",
	repository = "https://github.com/jolars/moloch",
	bugtracker = "https://github.com/jolars/moloch/issues",
	support = "https://github.com/jolars/moloch/discussions",
	home = "https://moloch.ink",
	topic = "presentation",
	announcement_file = "ctan_announcement.txt",
}
