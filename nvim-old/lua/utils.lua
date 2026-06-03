local getOS = function()
  if jit then
    return jit.os
  end

  local fh, err = assert(io.popen('uname -o 2>/dev/null', 'r'))
  local osname = nil
  if fh then
    osname = fh:read()
  end

  return osname or 'Windows'
end

return {
  getOS = getOS,
}
