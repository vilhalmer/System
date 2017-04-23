-- Attach to speakers when docking

dock_device_id = 0x8021
dock_watcher = hs.usb.watcher.new(function (device)
    if device['eventType'] == 'added' and device['productID'] == dock_device_id then
        hs.task.new('/usr/local/bin/bluectl', nil, {'Inspire S2', 'connect'}):start()
    end
end):start()

-- Wallpaper

wallpaper_adjuster = function ()
    hs.timer.doAfter(1, function () hs.osascript([[
        tell application "System Events"
            set theDesktops to a reference to every desktop
            set numberOfDesktops to the count of theDesktops
            if numberOfDesktops is 2 then
                set pictures folder of (item 1 of theDesktops) to "/Users/vil/.wallpaper/external"
                set pictures folder of (item 2 of theDesktops) to "/Users/vil/.wallpaper/internal"
            else
                set pictures folder of (item 1 of theDesktops) to "/Users/vil/.wallpaper/internal"
            end if
        end tell
    ]]) end)
end

screen_watcher = hs.screen.watcher.newWithActiveScreen(wallpaper_adjuster):start()
space_watcher = hs.spaces.watcher.new(wallpaper_adjuster):start()

-- Mouse reconnector

bluetooth_trigger = '04-69-f8-c4-e2-9c' -- Selectric

bluetooth_notification_processor = function (name, sender, userInfo)
    if sender == bluetooth_trigger then
        hs.task.new('/usr/local/bin/bluectl', function (code, stdout, stderr)
            if string.find(stdout, 'Connected') then
                -- This will occasionally cause suprious connection attempts, but that won't hurt anything.
                hs.task.new('/usr/local/bin/bluectl', function (code, stdout, stderr)
                    hs.notify.new({title='Bluetooth Watcher', informativeText='Attempted to reconnect MX Master'}):send()
                end, {'MX Master', 'connect'}):start()
            end
        end, {sender, 'status'}):start()
    end
end

bt_watcher = hs.distributednotifications.new(bluetooth_notification_processor, 'com.apple.bluetooth.deviceUpdated'):start()

-- Meta

meta_watcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.config/hammerspoon/', hs.reload):start()

-- External scripts

import = require 'import'

mpv = import('mpv')
download_fixer = import('download_fixer')
