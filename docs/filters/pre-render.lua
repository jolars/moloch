-- Pre-render script to extract version from build.lua
-- This runs before Quarto renders the documentation

local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local content = file:read("*all")
  file:close()
  return content
end

local function read_version()
  local content = read_file("../build.lua")
  if not content then
    return "unknown"
  end

  -- Extract version from: version = "1.1.0",
  local version = content:match('version%s*=%s*"([^"]+)"')
  return version or "unknown"
end

local function read_doc_channel()
  local channel = os.getenv("MOLOCH_DOC_CHANNEL")
  if not channel or channel == "" then
    return "local"
  end

  return channel
end

local function robots_for_channel(channel)
  if channel == "dev" then
    return "noindex,follow"
  end

  if channel:match("^texlive%-") then
    return "noindex,follow"
  end

  return "index,follow"
end

-- Set the version as a Quarto metadata variable
return {
  {
    Meta = function(meta)
      local version = read_version()
      local doc_channel = read_doc_channel()
      meta.version = version
      meta.doc_channel = doc_channel
      meta.robots = robots_for_channel(doc_channel)
      return meta
    end
  }
}
