---Normalize the given url by appending slash to the end of the url
---@param url string
---@return string
function URLNormalize(url)
  if string.match(url, '/$') == nil then
    return url .. '/'
  end
  return url
end
