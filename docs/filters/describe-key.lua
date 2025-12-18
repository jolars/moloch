-- Lua filter to convert .describe-key divs to appropriate format
-- Usage in markdown:
-- ::: {.describe-key key-name="alerted text" type="<color>" default="(theme-dependent)"}
-- Description text here
-- :::

function Div(el)
	if el.classes:includes("describe-key") then
		local key_name = el.attributes["key-name"]
		local type_val = el.attributes["type"]
		local default = el.attributes["default"]

		if not key_name or not type_val then
			return el -- Skip if missing required attributes
		end

		-- For LaTeX output
		if FORMAT:match("latex") then
			-- Build the LaTeX environment with content
			local result = {}
			table.insert(result, pandoc.RawBlock("latex", 
				string.format("\\begin{DescribeKey}{%s}{%s}{%s}", key_name, type_val, default or "")))
			for _, block in ipairs(el.content) do
				table.insert(result, block)
			end
			table.insert(result, pandoc.RawBlock("latex", "\\end{DescribeKey}"))

			return result
		end

		-- For HTML output
		if FORMAT:match("html") then
			local header = {}

			-- Add key name
			table.insert(header, pandoc.Span(pandoc.Str(key_name), pandoc.Attr("", { "key-name" })))
			table.insert(header, pandoc.Space())

			-- Add type in brackets
			table.insert(header, pandoc.Str("["))
			table.insert(header, pandoc.Span(pandoc.Emph(pandoc.Str(type_val)), pandoc.Attr("", { "key-type" })))
			table.insert(header, pandoc.Str("]"))

			-- Add default if provided
			if default and default ~= "" then
				table.insert(header, pandoc.Space())
				table.insert(header, pandoc.Str("—"))
				table.insert(header, pandoc.Space())
				table.insert(header, pandoc.Span(pandoc.Str("default: " .. default), pandoc.Attr("", { "key-default" })))
			end

			-- Prepend header to content
			table.insert(el.content, 1, pandoc.Para(header))

			return el
		end

		-- For other formats, return as-is
		return el
	end
end
