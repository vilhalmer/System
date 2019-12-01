#!/usr/bin/python
import argparse
from datetime import datetime
import json
import sys

from gi.repository import GLib
import pydbus


def sd_time(nanoseconds):
    return datetime.fromtimestamp(nanoseconds / (10 ** 6))


class UnitMonitor:
    def __init__(self, name, is_user, message):
        self.unit_name = name
        self.message = message

        self.bus = pydbus.SessionBus() if is_user else pydbus.SystemBus()
        self.sd = self.bus.get('.systemd1')
        self.sd.Subscribe()  # Enable signals.

        unit_path = self.sd.GetUnit(name)
        self.unit = self.get(unit_path)
        self.unit.onPropertiesChanged = self.properties_changed

        self.last_state_time = sd_time(self.unit.StateChangeTimestamp)
        self.update()

    def get(self, path):
        return self.bus.get('.systemd1', path)

    def properties_changed(self, iface, changed_props, invalid_props):
        # Currently we're only interested in watching for the unit starting and
        # stopping. The signal comes with a ton of stuff that isn't actually
        # changed, which means we are pretty much just using this call as a
        # trigger to go look at things again.

        # We get updates to multiple interfaces per change, so only listen to
        # one of them.
        if iface != 'org.freedesktop.systemd1.Unit':
            return

        # If the state hasn't changed since the last time we saw it, none of
        # the state information in this batch is useful.
        current_time = sd_time(self.unit.StateChangeTimestamp)
        if current_time <= self.last_state_time:
            return

        self.last_state_time = current_time
        self.update()

    def update(self):
        # "The following states are currently defined: active, reloading,
        # inactive, failed, activating, deactivating."
        if self.unit.ActiveState in ('active', 'activating', 'deactivating'):
            full_text = self.message
        elif self.unit.ActiveState in ('inactive', 'failed'):
            full_text = ''
        else:
            return

        print(
            json.dumps({
                'full_text': full_text,
            }, ensure_ascii=False),
            flush=True,
        )


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('unit_name', help="Unit to monitor, with extension")
    parser.add_argument('message', help="Message to display while running")
    parser.add_argument('--user', action='store_true', help="User mode")

    args = parser.parse_args()

    um = UnitMonitor(
        name=args.unit_name,
        is_user=args.user,
        message=args.message,
    )

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
