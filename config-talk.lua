#!/usr/bin/env texlua

---@diagnostic disable: lowercase-global

-- Test configuration for the ltx-talk theme.
--
-- The tests live in their own directory, and run under LuaTeX: ltx-talk is
-- built around tagged PDF, which is what most of its users are after, and
-- that is a LuaTeX story.
--
-- Both testsuppdir and stdengine have to be set explicitly. l3build derives
-- them from build.lua before this file is read, so leaving them out would
-- silently point the support-file copy at the Beamer fixtures and make
-- `l3build save` run pdfTeX.

testfiledir = "testfiles-talk"
testsuppdir = "testfiles-talk/support"

checkengines = { "luatex" }
stdengine = "luatex"

-- The class records the total frame count in the aux file, so the frame
-- number in the footer is only correct on a second pass.
checkruns = 2
