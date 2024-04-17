local string_utils = {}

function string_utils.split(s: string, sep: string): { string }
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(s, sep, from)
    while delim_from do
        table.insert(result, string.sub(s, from, delim_from - 1))
        from = delim_to :: number + 1
        delim_from, delim_to = string.find(s, sep, from)
    end
    table.insert(result, string.sub(s, from))
    return result
end

function string_utils.gmatch_arr(s: string, sep: string): { string }
    local res = {}
    for i in string.gmatch(s, sep) do
        table.insert(res, i)
    end
    return res
end
function string_utils.split_lines(s: string): { string }
    return string_utils.gmatch_arr(s .. "\n", "(.-)\n")
end

function string_utils.split_whitespace(s: string): { string }
    return string_utils.gmatch_arr(s, "%S+")
end

return string_utils
