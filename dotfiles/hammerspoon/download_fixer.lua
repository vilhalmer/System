local log = hs.logger.new('download_fixer', 5)

local blacklist = {
    '%.DS_Store',
    '/%.',
    '%.crdownload'
}

local file_blacklist = function (file)
    -- Blacklist for files that we always want to ignore.
    for i, pattern in ipairs(blacklist) do
        if string.match(file, pattern) then return false end
    end

    return true
end


local filter = function (table, condition)
    -- Why did I have to write this myself?
    local new_table = {}
    for i, item in ipairs(table) do
        if condition(item) then
            new_table[#new_table + 1] = item
        end
    end

    return new_table
end


function collect (...)
    -- …
    local new_table = {}
    for v in ... do
        table.insert(new_table, v)
    end

    return new_table
end


twitter_image, twitter_image_action = (function () -- Generate the filter so that we don't have to recalculate the length every call.
    local suffix = '-large'
    local suffix_len = string.len(suffix)

    return function (file) return string.sub(file, -suffix_len) == suffix and hs.fs.attributes(file) end,
           function (file) hs.task.new('/bin/mv', nil, {file, string.sub(file, 1, string.len(file) - suffix_len)}):start() end
end)()

audio = function (file)
    local filename = nil
    for component in string.gmatch(file, '[^/]+') do filename = component end -- Grab the last thing.

    command = 'mdfind "kMDItemContentTypeTree == public.audio" -onlyin $(dirname "' .. file .. '") | grep "' .. filename .. '" 2>&1 >/dev/null'
    return hs.task.new('/bin/bash', nil, {'-c', command}):start():waitUntilExit():terminationStatus() == 0
end

audio_action = function (file)
    log.i('Found audio: ' .. filename)
    local components = collect(string.gmatch(file, '[^/]+'))
    components.remove() -- Drop the filename.
    local audio_path = '/' .. table.concat(components, '/') .. '/audio/' -- Add /audio/ to the dirname.

    command = 'mkdir -p ' .. audio_path .. ' && mv -n ' .. file .. ' ' .. audio_path
    hs.task.new('/bin/bash', nil, {'-c', command}):setCallback(function () log.i('Moved ' .. file) end):start()
end


local filters = {
    [twitter_image] = twitter_image_action,
    --[audio] = audio_action, -- Not working yet…
}

local fix_downloads = function (files)
    for i, file in ipairs(filter(files, file_blacklist)) do
        for filter, action in pairs(filters) do
            if filter(file) then
                return action(file) -- Only do one per round, in case the file is changed by the action.
            end
        end
    end
end

local watcher = hs.pathwatcher.new(os.getenv('HOME') .. '/Downloads/', fix_downloads):start()
return watcher
