-- Pre-render script to extract version from build.lua
-- This runs before Quarto renders the documentation

local function read_version()
  local build_file = io.open("../build.lua", "r")
  if not build_file then
    return "unknown"
  end
  
  local content = build_file:read("*all")
  build_file:close()
  
  -- Extract version from: version = "1.1.0",
  local version = content:match('version%s*=%s*"([^"]+)"')
  return version or "unknown"
end

-- Set the version as a Quarto metadata variable
return {
  {
    Meta = function(meta)
      local version = read_version()
      meta.version = version
      return meta
    end
  }
}
