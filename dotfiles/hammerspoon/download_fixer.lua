local suffix = '-large'
local suffix_len = string.len(suffix)

local fix_downloads = function (files)
    for i, file in ipairs(files) do
        if string.sub(file, -suffix_len) == suffix and hs.fs.attributes(file) then
            hs.task.new('/bin/mv', nil, {file, string.sub(file, 1, string.len(file) - suffix_len)}):start()
        end
    end
end

local watcher = hs.pathwatcher.new(os.getenv('HOME') .. '/Downloads/', fix_downloads):start()
