#!/usr/bin/env python
from functools import partial
import json
import sys

from gi.repository import GLib
import pydbus


COLOR_BAD = '#f9b381ff'
COLOR_WARN = '#ffff00ff'
COLOR_FINE = '#ffffffff'
COLOR_INACTIVE = '#ffffff55'


UUID_AIRPODS = '74ec2172-0bad-4d01-8f77-997b2be0722a'  # Complete guess.
BT_ID_APPLE = 0x004C


def airpod_percent(reported, is_left):
    """
    The reported value is 0-10 representing 10% increments, 15 is disconnected.
    Return a block icon that represents the value as closely as possible.
    """
    if reported == 15:
        return ''

    if reported > 7:
        return '⣿'
    if reported > 6:
        return '⣾' if is_left else '⣷'
    if reported > 5:
        return '⣶'
    if reported > 4:
        return '⣴' if is_left else '⣦'
    if reported > 3:
        return '⣤'
    if reported > 2:
        return '⣠' if is_left else '⣄'
    if reported > 1:
        return '⣀'
    if reported > 0:
        return '⢀' if is_left else '⡀'

    return '⠀'


class BluetoothStatus:
    icon = '\uf294\u2009'

    def __init__(self):
        self.tracked_devices = {}
        self.print_count = True
        self.recent_change = None
        self.airpods_adapter = None
        self.airpods_battery = (0, 0)

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
                device = self.bus.get('org.bluez', path)

                if path not in self.tracked_devices:
                    # Only set up a handler the first time we see a device.
                    device.onPropertiesChanged = partial(self.handle_event, device)
                    previously_connected = False
                else:
                    previously_connected = (
                        self.tracked_devices[path]['Connected']
                    )

                if device.Connected and not previously_connected:
                    # Display the newly connected device name for a moment.
                    self.recent_change = self._dev_name(device_info)

                    GLib.timeout_add_seconds(
                        3, self.clear_recent, self.recent_change
                    )

                if UUID_AIRPODS in device.UUIDs:
                    self.monitor_airpods_battery(device)

                # But always update device properties.
                self.tracked_devices[path] = device_info

    @property
    def connected_devices(self):
        return (
            self._dev_name(dev) for dev in self.tracked_devices.values()
            if dev['Connected']
        )

    def monitor_airpods_battery(self, device):
        """
        The Airpods broadcast their battery status using an ephemeral LE
        MAC address, which means we can't actually tell if they're our
        Airpods. We have to listen to all devices. To avoid wasting time
        and energy, we only do this when a set of Airpods are connected.

        There must be _some_ way of correlating them, but no one seems to
        have figured it out.
        """
        if self.airpods_adapter:
            if not device.Connected:  # Airpods disconnected, stop monitoring.
                try:
                    self.airpods_adapter.StopDiscovery()
                except Exception:
                    pass

                self.airpods_battery = (0, 0)
                self.airpods_adapter = None

            return

        if device.Connected:
            self.airpods_adapter = self.bus.get('org.bluez', device.Adapter)
            try:
                self.airpods_adapter.StopDiscovery()  # Stop any existing discovery.
            except Exception:
                pass  # No discovery started (36)

            self.airpods_adapter.SetDiscoveryFilter({
                'Discoverable': pydbus.Variant('b', False),
                'RSSI': pydbus.Variant('n', -60),  # Stolen from OpenPods.
            })
            self.airpods_adapter.StartDiscovery()

    def update_airpods_battery(self, manufacturer_apple):
        # TODO: Flipped: Integer.toString(Integer.parseInt( + str.charAt(10), 16) + 0x10, 2).charAt(3) == '0'; WTF
        left = airpod_percent(manufacturer_apple[6] >> 4, is_left=True)
        right = airpod_percent(manufacturer_apple[6] & 0xf, is_left=False)
        self.airpods_battery = left, right

    def handle_event(self, device, *args):
        if self.airpods_adapter:
            try:
                manufacturer_apple = args[1]['ManufacturerData'][BT_ID_APPLE]
            except (IndexError, KeyError):
                pass
            else:
                if len(manufacturer_apple) == 27:
                    self.update_airpods_battery(manufacturer_apple)
                    self.print_status()

        if device.Paired:
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
            devices = str(count if count > 0 else '')
        else:
            devices = ' + '.join(self.connected_devices)

        if any(self.airpods_battery):
            l, r = self.airpods_battery
            devices += f'   {l} {r}'

        print(
            json.dumps({
                'full_text': f"{self.icon}{' ' if devices else ''}{devices}",
                'color': COLOR_FINE if count else COLOR_INACTIVE,
            }, ensure_ascii=False),
            flush=True
        )

    def clean_up(self):
        if self.airpods_adapter:
            try:
                self.airpods_adapter.StopDiscovery()
            except Exception:
                pass  # No discovery started (36)


if __name__ == '__main__':
    status = BluetoothStatus()
    status.update_devices()
    status.print_status()

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

    status.clean_up()
