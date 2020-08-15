#!/usr/bin/env python
import json
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
        self.recent_change = None

        self.bus = pydbus.SystemBus()
        self.manager = self.bus.get('org.bluez', '/')

    @staticmethod
    def _dev_name(device):
        return device.get('Name', device['Address'])

    def clear_recent(self, expected_recent):
        if self.recent_change == expected_recent:
            self.recent_change = None
            self.print_status()

        return False  # Don't reschedule this timer.

    def update_devices(self):
        for path, interfaces in self.manager.GetManagedObjects().items():
            if 'org.bluez.Device1' in interfaces:
                device_info = interfaces['org.bluez.Device1']

                if path not in self.tracked_devices:
                    # Only set up a handler the first time we see a device.
                    device = self.bus.get('org.bluez', path)
                    device.onPropertiesChanged = self.handle_event
                    previously_connected = False
                else:
                    previously_connected = (
                        self.tracked_devices[path]['Connected']
                    )

                if device_info['Connected'] and not previously_connected:
                    # Display the newly connected device name for a moment.
                    self.recent_change = self._dev_name(device_info)
                    GLib.timeout_add_seconds(
                        3, self.clear_recent, self.recent_change
                    )

                # But always update device properties.
                self.tracked_devices[path] = device_info

    @property
    def connected_devices(self):
        return (
            self._dev_name(dev) for dev in self.tracked_devices.values()
            if dev['Connected']
        )

    def handle_event(self, *args):
        self.update_devices()
        self.print_status()

    def toggle_mode(self):
        self.print_count = not self.print_count
        self.print_status()

    def print_status(self):
        count = len(list(self.connected_devices))
        if self.recent_change:
            devices = self.recent_change
        elif self.print_count:
            devices = count if count > 1 else ''
        else:
            devices = ' + '.join(self.connected_devices)

        print(
            json.dumps({
                'full_text': f"{self.icon}{' ' if devices else ''}{devices}",
                'color': COLOR_FINE if count else COLOR_INACTIVE,
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
