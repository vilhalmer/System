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

-- Battery time

battery_menulet = hs.menubar.new(false)
time_remaining = function ()
    minutes_remaining = hs.battery.timeRemaining()

    if minutes_remaining < 0 then
        time = '✓'
    else
        hours = math.floor(minutes_remaining / 60)
        minutes = minutes_remaining % 60
        time = string.format("%d:%02d", hours, minutes)
    end

    time = hs.styledtext.new(time, {
        font={name=hs.styledtext.defaultFonts.menuBar, size=12}
    })

    battery_menulet:returnToMenuBar()
    battery_menulet:setTitle(time)
end
battery_watcher = hs.battery.watcher.new(time_remaining):start()
time_remaining()

-- Audio source

audio_menulet = hs.menubar.new(false)
audio_device = function (_)
    device = hs.audiodevice.defaultOutputDevice():name()

    device = hs.styledtext.new(device, {
        font={name=hs.styledtext.defaultFonts.menuBar, size=12}
    })

    audio_menulet:returnToMenuBar()
    audio_menulet:setTitle(device)
end
hs.audiodevice.watcher.setCallback(audio_device)
hs.audiodevice.watcher.start()
audio_device()

-- Meta

meta_watcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.config/hammerspoon/', hs.reload):start()

-- External scripts

import = require 'import'

mpv = import('mpv')
download_fixer = import('download_fixer')
