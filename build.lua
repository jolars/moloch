#!/usr/bin/env texlua

---@diagnostic disable: lowercase-global
module = "moloch"

sourcefiledir = "src"
docfiledir = "docs"
typesetfiles = { "*.tex" }
textfiles = { "*.md", "LICENSE" }
checkengines = { "pdftex" }
checksuppfiles = { "*.tex" }

packtdszip = false

maxprintline = 9999

uploadconfig = {
	pkg = "moloch",
	version = "1.1.0",
	author = "Johan Larsson",
	uploader = "Johan Larsson",
	license = "cc-by-sa-4",
	summary = "A Minimalist and Functional Beamer Theme",
	description = "Moloch is a minimalist and functional theme. "
		.. "It is a fork of the Metropolis theme.",
	ctanPath = "/macros/latex/contrib/beamer-contrib/themes/moloch",
	repository = "https://github.com/jolars/moloch",
	bugtracker = "https://github.com/jolars/moloch/issues",
	support = "https://github.com/jolars/moloch/discussions",
	topic = "presentation",
	announcement_file = "ctan_announcement.txt",
}
