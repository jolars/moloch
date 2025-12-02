-- Pandoc Lua filter to add latex class to code blocks

function CodeBlock(el)
  -- Set the class to latex for syntax highlighting
  el.classes = {"latex"}
  return el
end

return {{CodeBlock = CodeBlock}}
