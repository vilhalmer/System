local log = hs.logger.new('mpv', 5)

local mpv_command = function (...)
    return hs.json.encode({command={...}}) .. '\n'
end

local menulet = hs.menubar.new(false)


local observed_properties = {'pause', 'metadata'}


local actions = {}

actions.pause = function (data)
    -- TODO
end

actions.metadata = function (data)
    menulet:returnToMenuBar()
    menulet:setTitle(data['icy-title'])
end

local mpv_read = function (event, tag)
    event = hs.json.decode(event)
    log.i(hs.inspect.inspect(event))

    if event['event'] == 'property-change' or event['error'] == 'success' then
        if event['data'] ~= nil and actions[event['name']] ~= nil then
            actions[event['name']](event['data']) -- Call the handler defined above.
        end

    elseif event['event'] == 'end-file' then -- TODO: Clean this up.
        menulet:removeFromMenuBar()
    end

    mpv_socket:read('\n')
end

local mpv = function ()
    mpv_socket = hs.socket.new():connect(os.getenv('HOME') .. '/.cache/mpvsocket')

    mpv_socket:setCallback(mpv_read)

    for i, property in ipairs(observed_properties) do
        mpv_socket:write(mpv_command('observe_property', 0, property))
        mpv_socket:write(mpv_command('get_property', property))
    end

    mpv_socket:read('\n')
end
mpv()

local mpv_watcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.cache/mpvsocket', mpv):start()
