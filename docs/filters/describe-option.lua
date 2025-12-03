-- Lua filter to convert .describe-option divs to appropriate format
-- Usage in markdown:
-- ::: {.describe-option option-name="titleformat" values="regular, smallcaps" default="regular"}
-- Description text here
-- :::

function Div(el)
	if el.classes:includes("describe-option") then
		local option_name = el.attributes["option-name"]
		local values = el.attributes["values"]
		local default = el.attributes["default"]

		if not option_name or not values then
			return el -- Skip if missing required attributes
		end

		-- For LaTeX output
		if FORMAT:match("latex") then
			-- Extract the description text
			local description = pandoc.write(pandoc.Pandoc(el.content), "latex")

			-- Build the LaTeX command
			local latex =
				string.format("\\DescribeOption{%s}{%s}{%s}{%s}", option_name, values, default or "", description)

			return pandoc.RawBlock("latex", latex)
		end

		-- For HTML output
		if FORMAT:match("html") then
			local header = {}

			-- Add option name
			table.insert(header, pandoc.Span(pandoc.Str(option_name), pandoc.Attr("", { "option-name" })))
			table.insert(header, pandoc.Space())

			-- Build the header line with values in brackets, highlighting default
			table.insert(header, pandoc.Str("["))

			if default then
				-- Split values and highlight the default one
				local value_parts = {}
				for value in string.gmatch(values, "([^,]+)") do
					local trimmed = value:match("^%s*(.-)%s*$") -- trim whitespace
					if trimmed == default then
						table.insert(value_parts, pandoc.Underline(pandoc.Strong(pandoc.Str(trimmed))))
					else
						table.insert(value_parts, pandoc.Str(trimmed))
					end
				end

				-- Insert values with commas
				for i, part in ipairs(value_parts) do
					table.insert(header, part)
					if i < #value_parts then
						table.insert(header, pandoc.Str(","))
						table.insert(header, pandoc.Space())
					end
				end
			else
				table.insert(header, pandoc.Span(pandoc.Emph(pandoc.Str(values)), pandoc.Attr("", { "option-values" })))
			end

			table.insert(header, pandoc.Str("]"))

			-- Prepend header to content
			table.insert(el.content, 1, pandoc.Para(header))

			return el
		end

		-- For other formats, return as-is
		return el
	end
end
