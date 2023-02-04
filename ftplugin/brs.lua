if vim then
  vim.b.match_ignorecase = true
end

--[[ Replace all spans of 1+ spaces in a token with '\s+' ]]--
function replace_spaces (token)
  local result = token:gsub('%s+', '\\s\\+')
  return result
end

--[[
Create a look-behind regex which includes all of the provided tokens.  This is
ensures that when 'block' is focused in 'end block', that matchit correctly
recognizes it as the end of a match word rather than the beginning.
]]--
function build_not_token (tokens)
  local result = '\\%(\\<\\('
  result = result .. table.concat(tokens, '\\|')
  result = result .. '\\)\\s\\+\\)\\@<!'
  result = replace_spaces(result)
  return result
end

--[[ Replace spaces in token and wraps result in word boundary regexes. ]]--
function build_token (token)
  local result = '\\<'
  result = result .. replace_spaces(token)
  result = result .. '\\>'
  return result
end

--[[ Build complete match words.

@tokens (array of strings) ordered list of tokens
@not_tokens (array of string) tokens to include in inverse-match look-behind

Example:

    build_match_word({'if', 'else if', 'else', 'end if'}, {'end'})
]]--
function build_match_word(tokens, not_tokens)
  not_tokens = not_tokens or {}

  if #tokens == 0 then
    return ''
  end

  local result = {}

  for _, token in ipairs(tokens) do
    local built_token = build_token(token)
    table.insert(result, built_token)
  end

  if #not_tokens > 0 then
    local not_token = build_not_token(not_tokens)
    result[1] = not_token .. result[1]
  end

  local result_str = table.concat(result, ':')
  return result_str
end

--[[ Build match word and add it to `b:match_words` ]]--
function add_match_word(tokens, not_tokens)
  match_word = build_match_word(tokens, not_tokens)
  if not vim then
    print(match_word)
  elseif not vim.b.match_words then
    vim.b.match_words = match_word
  else
    vim.b.match_words = vim.b.match_words .. ',' .. match_word
  end
end

-- Main
add_match_word({'function', 'end function'}, {'end'})
add_match_word({'sub', 'end sub'}, {'end'})
add_match_word({'if', 'else if', 'else', 'end if'}, {'end', 'else'})
add_match_word({'for','to','end for','step','exit for'}, {'end', 'exit'})
add_match_word({'for each','in','end for','exit for'}, {'end', 'exit'})
add_match_word({'while','end while','exit while'}, {'end', 'exit'})
add_match_word({'try','catch','end try'}, {'end'})
