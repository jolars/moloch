#!/usr/bin/env texlua

---@diagnostic disable: lowercase-global
module = "moloch"

sourcefiledir = "src"
docfiledir = "doc"
typesetfiles = { "*.tex" }
textfiles = { "*.md", "LICENSE" }
checkengines = { "pdftex" }
checksuppfiles = { "*.tex" }

packtdszip = false

maxprintline = 9999

uploadconfig = {
	pkg = "moloch",
	version = "1.0.1",
	author = "Johan Larsson",
	uploader = "Johan Larsson",
	license = "cc-by-sa-4",
	summary = "A clean and simple beamer theme",
	description = "Moloch is a clean and simple beamer theme. "
		.. "It is a fork of the Metropolis theme, but has a "
		.. "more minimalistic and slightly less opinionated design.",
	ctanPath = "/macros/latex/contrib/beamer-contrib/themes/moloch",
	repository = "https://github.com/jolars/moloch",
	bugtracker = "https://github.com/jolars/moloch/issues",
	support = "https://github.com/jolars/moloch/discussions",
	topic = "presentation",
	announcement_file = "ctan_announcement.txt",
}
