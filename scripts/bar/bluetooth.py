#!/usr/bin/env python
import json
import signal
import sys

from gi.repository import GLib
import pydbus


COLOR_BAD = '#f9b381ff'
COLOR_WARN = '#ffff00ff'
COLOR_FINE = '#ffffffff'
COLOR_INACTIVE = '#ffffff55'


class BluetoothStatus:
    icon = '\uf294\u2009'

    def __init__(self):
        self.tracked_devices = {}
        self.print_count = True

        self.bus = pydbus.SystemBus()
        self.manager = self.bus.get('org.bluez', '/')

    def update_devices(self):
        for path, interfaces in self.manager.GetManagedObjects().items():
            if 'org.bluez.Device1' in interfaces:
                if path not in self.tracked_devices:
                    # Only set up a handler the first time we see a device.
                    device = self.bus.get('org.bluez', path)
                    device.onPropertiesChanged = self.handle_event

                # But always update device properties.
                self.tracked_devices[path] = interfaces['org.bluez.Device1']

    @property
    def connected_devices(self):
        return (
            dev['Name'] for dev in self.tracked_devices.values()
            if dev['Connected']
        )

    def handle_event(self, *args):
        self.update_devices()
        self.print_status()

    def toggle_mode(self):
        self.print_count = not self.print_count
        self.print_status()

    def print_status(self):
        if self.print_count:
            devices = len(list(self.connected_devices)) or ''
        else:
            devices = ' + '.join(self.connected_devices)

        print(
            json.dumps({
                'full_text': f"{self.icon}{' ' if devices else ''}{devices}",
                'color': COLOR_FINE if devices else COLOR_INACTIVE,
            }, ensure_ascii=False),
            flush=True
        )


if __name__ == '__main__':
    status = BluetoothStatus()
    status.handle_event()  # Draw immediately.

    loop = GLib.MainLoop()

    def handle_stdin(channel, message, *data):
        if message == GLib.IO_HUP:
            loop.quit()
        else:
            channel.readline()
            status.toggle_mode()
        return True

    stdin_channel = GLib.IOChannel(sys.stdin.fileno())
    GLib.io_add_watch(stdin_channel, 0, GLib.IO_IN | GLib.IO_HUP, handle_stdin)
    try:
        loop.run()
    except KeyboardInterrupt:
        pass
