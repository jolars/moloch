-- Pandoc Lua filter to convert indented code blocks to fenced latex blocks
-- and convert \|text\| to inline code

function CodeBlock(el)
	-- Set the class to latex for syntax highlighting
	el.classes = { "latex" }
	return el
end

function Str(el)
	-- Convert \| to nothing, letting the RawInline handle the code formatting
	if el.text:match("^\\|$") then
		return {}
	end
	return el
end

function RawInline(el)
	-- Convert \|...\| patterns to inline code
	if el.format == "tex" then
		local content = el.text:match("^\\|(.-)\\|$")
		if content then
			return pandoc.Code(content)
		end
	end
	return el
end

function Div(el)
	-- Convert ::: macro divs to definition lists with backtick-wrapped terms
	if el.classes[1] == "macro" then
		-- Get the first paragraph as the macro name/description
		local first_para = el.content[1]
		if first_para and first_para.t == "Para" then
			-- Extract macro name (first word/element) and description
			local macro_name_elem = first_para.content[1]

			-- Extract text for macro name
			local macro_text = ""
			if macro_name_elem.t == "Str" then
				macro_text = macro_name_elem.text
			elseif macro_name_elem.t == "Code" then
				macro_text = macro_name_elem.text
			else
				-- Try to get text somehow
				macro_text = pandoc.utils.stringify(macro_name_elem)
			end

			local description = {}

			-- Get the rest as description
			for i = 2, #first_para.content do
				table.insert(description, first_para.content[i])
			end

			-- Build definition list with code-formatted term
			local def_list = pandoc.DefinitionList({
				{
					{ pandoc.Code(macro_text) }, -- term with backticks
					{ { pandoc.Plain(description) } }, -- definition
				},
			})

			-- Add remaining content after the definition list
			local result = { def_list }
			for i = 2, #el.content do
				table.insert(result, el.content[i])
			end

			return result
		end
	end
	return el
end

return { { CodeBlock = CodeBlock, Str = Str, RawInline = RawInline, Div = Div } }
