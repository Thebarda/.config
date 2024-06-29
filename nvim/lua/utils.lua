local getOS = function()
  local OS = package.cpath:match("%p[\\|/]?%p(%a+)")

  if OS == 'dll' then
    return "Windows"
  end

  if OS == 'so' then
    return "Linux"
  end

  if OS == "dylib" then
    return "MacOS"
  end

  return nil
end

return {
  getOS = getOS
}
