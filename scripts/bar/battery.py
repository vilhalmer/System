#!/usr/bin/env python
from datetime import timedelta
import json
import sys

import pydbus
from gi.repository import GLib


COLOR_BAD = '#f9b381ff'
COLOR_WARN = '#ffff00ff'
COLOR_FINE = '#ffffffff'
COLOR_INACTIVE = '#fffff55'
COLOR_GOOD = '#88ff88ff'


TIME_WARN = timedelta(seconds=60 * 60)
TIME_BAD = timedelta(seconds=60 * 20)


def icon(percent, charging):
    if charging:
        return ' '

    if percent >= 90:
        return ' '
    elif percent >= 75:
        return ' '
    elif percent >= 50:
        return ' '
    elif percent >= 10:
        return ' '
    else:
        return ' '


def pretty_time(delta):
    """
    String representation of `delta` ending at minute resolution.
    """
    return str(delta).rsplit(':', 1)[0]


class BatteryStatus:
    def __init__(self):
        self.bus = pydbus.SystemBus()
        self.upower = self.bus.get('.UPower')

        self.upower.onDeviceAdded = lambda *_: self.watch_all()
        self.upower.onPropertiesChanged = lambda *_: self.update()  # OnBattery

        # A little bit of unfortunate state to keep track of, to work around
        # garbage data.
        self.previous_text = f"{icon(100, False)} ?"
        self.previous_charging = not self.upower.OnBattery

        self.bus.watch_name(
            'org.freedesktop.UPower',
            name_appeared=lambda *_: self.watch_all(),
            name_vanished=lambda *_: self.watch_all(),
        )

    @property
    def batteries(self):
        try:
            devices = self.upower.EnumerateDevices()
        except GLib.Error:  # UPower isn't running.
            return []

        return [
            self.bus.get('.UPower', device_path)
            for device_path in devices
            if device_path.rsplit('/', 1)[1].startswith('battery_')
        ]

    def watch_all(self):
        """
        Enumerate battery devices and watch PropertiesChanged for all of them.
        """
        for batt in self.batteries:
            batt.onPropertiesChanged = lambda *_: self.update()

        self.update()

    def update(self):
        color = COLOR_FINE

        total_capacity = 0.0
        remaining_capacity = 0.0
        discharge_rate = 0.0

        for batt in self.batteries:
            total_capacity += batt.EnergyFull
            remaining_capacity += batt.Energy
            discharge_rate += batt.EnergyRate

        charging = not self.upower.OnBattery

        if total_capacity == 0.0:
            # No batteries present, display nothing.
            full_text = ""
            time_remaining = timedelta.max

        elif discharge_rate < 1.0 and not (charging or self.previous_charging):
            # At the point where the system switches to the secondary battery,
            # UPower will momentarily report that neither of them are
            # discharging at a significant rate. Throw out that measurement.
            # However, this also happens occasionally when transitioning from
            # AC to battery. If that state changed, we still want to update
            # in order to change the icon. Finally, it is also the case when
            # we're on AC and the battery is full.
            # (1.0 is chosen at random, the bogus measurement is 0.0111 W.)
            full_text = self.previous_text

        else:
            # XXX: The UPower documentation says that discharge_rate is
            # negative when the battery is charging. This is a lie. I've left
            # the `abs` calls in place anyway in case this is true on other
            # systems, but we're looking at OnBattery instead.
            percent = int(remaining_capacity / total_capacity * 100)
            full_text = icon(percent, charging)

            if charging:
                hours_remaining = (
                    (total_capacity - remaining_capacity) / abs(discharge_rate)
                )
            else:
                hours_remaining = remaining_capacity / abs(discharge_rate)

            time_remaining = timedelta(seconds=hours_remaining * 3600)

            # Only display an estimate if we have reasonable data.
            if percent < 100 and discharge_rate > 1.0:
                full_text += f" {pretty_time(time_remaining)}"

                if charging:
                    color = COLOR_GOOD
                else:
                    if time_remaining < TIME_BAD:
                        color = COLOR_BAD
                    elif time_remaining < TIME_WARN:
                        color = COLOR_WARN
            elif charging:
                full_text = ""

        self.previous_text = full_text
        self.previous_charging = charging

        print(
            json.dumps({
                'full_text': full_text,
                'color': color,
            }, ensure_ascii=False),
            flush=True,
        )


def main():
    status = BatteryStatus()
    loop = GLib.MainLoop()

    def handle_stdin(channel, message, *data):
        if message == GLib.IO_HUP:
            loop.quit()
        return True

    stdin_channel = GLib.IOChannel(sys.stdin.fileno())
    GLib.io_add_watch(stdin_channel, 0, GLib.IO_IN | GLib.IO_HUP, handle_stdin)
    try:
        loop.run()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
