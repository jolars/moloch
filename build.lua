#!/usr/bin/env texlua

module = "moloch"

sourcefiledir = "src"
docfiledir = "doc"
typesetfiles = { "*.tex" }
textfiles = { "*.md", "LICENSE" }
checkengines = { "pdftex" }
checksuppfiles = { "*.tex" }

packtdszip = true

maxprintline = 9999

uploadconfig = {
  pkg = "moloch",
  version = "0.3.0", -- x-release-please-version
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
  update = false,
}

function update_tag(file, content, tagname, tagdate)
  if string.match(file, "%.dtx$") then
    local pattern = "\\ProvidesPackage{(.-)}%[([^%]]-) v([^%]]-) ([^%]]-)%]"
    return content:gsub(
      pattern,
      function(package_name, old_date, old_version, description)
        -- if tagdate is nil, use old_date
        if tagname == nil then
          tagname = old_version
        end

        return string.format(
          "\\ProvidesPackage{%s}[%s v%s %s]",
          package_name,
          tagdate,
          tagname,
          description
        )
      end
    )
  end

  return content
end
