#!/usr/bin/env texlua

-- DTX documentation extractor with Pandoc conversion
-- Extracts documentation from .dtx files and converts to Markdown

function extract_docs(dtx_file, latex_file)
	local infile = io.open(dtx_file, "r")
	if not infile then
		print("Error: Could not open " .. dtx_file)
		return false
	end

	local outfile = io.open(latex_file, "w")
	if not outfile then
		print("Error: Could not create " .. latex_file)
		infile:close()
		return false
	end

	local skip_until_package = true
	local in_macrocode = false
	local code_lines = {}

	for line in infile:lines() do
		-- Skip everything until we see the package start guard
		if skip_until_package then
			if line:match("^%%<.*package>") then
				skip_until_package = false
			end
			goto continue
		end

		-- Skip docstrip guards
		if line:match("^%%<") then
			goto continue
		end

		-- Skip special DTX commands
		if
			line:match("^%% \\CheckSum")
			or line:match("^%% \\StopEventually")
			or line:match("^%% \\Finale")
			or line:match("^%% \\iffalse")
			or line:match("^%% \\fi")
			or line:match("^%% %-%-%-%-") -- Skip separator lines
			or line:match("^%% \\subsection") -- Skip subsection headers (we have YAML title)
		then
			goto continue
		end

		-- Handle macrocode blocks - convert to verbatim for Pandoc
		if line:match("\\begin{macrocode}") then
			in_macrocode = true
			code_lines = {}
			outfile:write("\n\\begin{verbatim}\n")
			goto continue
		end

		if line:match("\\end{macrocode}") then
			in_macrocode = false
			for _, code_line in ipairs(code_lines) do
				outfile:write(code_line .. "\n")
			end
			outfile:write("\\end{verbatim}\n\n")
			code_lines = {}
			goto continue
		end

		if in_macrocode then
			-- Remove leading "%    " from code lines
			local code = line:gsub("^%%    ", "")
			table.insert(code_lines, code)
		elseif line:match("^%% ") or line:match("^%%$") then
			-- Documentation line (LaTeX format) - remove leading "% " or "%"
			local doc = line:gsub("^%% ?", "")
			outfile:write(doc .. "\n")
		end

		::continue::
	end

	infile:close()
	outfile:close()

	return true
end

function convert_to_markdown(latex_file, markdown_file, filter_file)
	-- Convert LaTeX to Markdown using Pandoc with filter
	local cmd = string.format(
		"pandoc %s -f latex -t markdown --lua-filter=%s -o %s 2>&1",
		latex_file,
		filter_file,
		markdown_file
	)

	local result = os.execute(cmd)
	return result == 0 or result == true
end

-- Main execution
function main()
	local src_dir = "src"
	local out_dir = "docs/implementation"
	local filter_file = "convert-filter.lua"

	-- Create output directory
	os.execute("mkdir -p " .. out_dir)

	-- Ensure filter exists
	local filter = io.open(filter_file, "r")
	if not filter then
		print("Error: " .. filter_file .. " not found")
		print("Creating default filter...")
		filter = io.open(filter_file, "w")
		filter:write([[-- Pandoc Lua filter to add latex class to code blocks

function CodeBlock(el)
  -- Set the class to latex for syntax highlighting
  el.classes = {"latex"}
  return el
end

return {{CodeBlock = CodeBlock}}
]])
		filter:close()
	else
		filter:close()
	end

	-- List of DTX files to process with display names
	local dtx_files = {
		{ name = "beamerthememoloch", title = "Main Theme" },
		{ name = "beamerinnerthememoloch", title = "Inner Theme" },
		{ name = "beamerouterthememoloch", title = "Outer Theme" },
		{ name = "beamerfontthememoloch", title = "Font Theme" },
		{ name = "beamercolorthememoloch", title = "Color Theme" },
		{ name = "beamercolorthememoloch-tomorrow", title = "Color Theme: Tomorrow" },
		{ name = "beamercolorthememoloch-highcontrast", title = "Color Theme: High Contrast" },
	}

	print("Extracting and converting DTX documentation...\n")

	local success_count = 0
	for _, file_info in ipairs(dtx_files) do
		local basename = file_info.name
		local title = file_info.title
		local dtx = src_dir .. "/" .. basename .. ".dtx"
		local latex = out_dir .. "/" .. basename .. ".tex"
		local md = out_dir .. "/" .. basename .. ".md"

		-- Step 1: Extract to LaTeX
		if extract_docs(dtx, latex) then
			-- Step 2: Convert to Markdown
			if convert_to_markdown(latex, md, filter_file) then
				-- Step 3: Add YAML frontmatter
				local infile = io.open(md, "r")
				local content = infile:read("*all")
				infile:close()

				local outfile = io.open(md, "w")
				outfile:write("---\n")
				outfile:write('title: "' .. title .. '"\n')
				outfile:write("---\n\n")
				outfile:write(content)
				outfile:close()

				print("Converted: " .. dtx .. " -> " .. md)
				-- Clean up intermediate LaTeX file
				os.execute("rm " .. latex)
				success_count = success_count + 1
			else
				print("Error converting: " .. latex)
			end
		end
	end

	print("\nDone! Converted " .. success_count .. " files to " .. out_dir .. "/")
end

-- Run the script
main()
