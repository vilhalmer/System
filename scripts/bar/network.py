#!/usr/bin/env python
import array
import json
import sys
import time

import pydbus
from gi.repository import GLib


COLOR_BAD = '#f9b381ff'
COLOR_WARN = '#ffff00ff'
COLOR_FINE = '#ffffffff'
COLOR_INACTIVE = '#fffff55'


NM_STATE_UNKNOWN = 0
NM_STATE_ASLEEP = 10
NM_STATE_DISCONNECTED = 20
NM_STATE_DISCONNECTING = 30
NM_STATE_CONNECTING = 40
NM_STATE_CONNECTED_LOCAL = 50
NM_STATE_CONNECTED_SITE = 60
NM_STATE_CONNECTED_GLOBAL = 70


def dbus_bytes_to_str(byte_list):
    return array.array('B', byte_list).tobytes().decode('utf-8')


def type_icon(conn_type):
    if conn_type == '802-11-wireless':
        return '\uf1eb\u2009'
    elif conn_type == 'ethernet':
        return '\uf796\u2009'
    elif conn_type == 'vpn':
        return '\uf023\u2009'
    else:
        return '\uf6ff\u2009'


class NetworkStatus:
    def __init__(self):
        self.bus = pydbus.SystemBus()
        self.nm = self.bus.get('.NetworkManager')
        self.extra = []

        # Watch for NetworkManager restarts so the info doesn't remain stale
        # until it gets around to reconnecting. The arguments are incorrect, so
        # eat them.
        self.bus.watch_name(
            'org.freedesktop.NetworkManager',
            name_vanished=lambda: self.state_changed(NM_STATE_UNKNOWN),
        )

        self.nm.onPropertiesChanged = self.properties_changed

        # Trigger immediately for the current state.
        self.connections_changed(self.nm.ActiveConnections)

    def get(self, object_path):
        return self.bus.get('.NetworkManager', object_path)

    def properties_changed(self, properties):
        for prop, value in properties.items():
            if prop == 'State':
                self.state_changed(value)
            elif prop == 'ActiveConnections':
                self.connections_changed(value)

    def connections_changed(self, connections):
        """
        Look through the non-primary connections to see if any of them are
        interesting enough to display (currently just VPN).
        """
        # Reset the current state in case connections have disappeared.
        self.extra = []

        for conn_path in connections:
            if conn_path == self.nm.PrimaryConnection:
                continue

            connection = self.get(conn_path)
            if connection.Type in ('vpn',):
                self.extra.append(connection)

        self.state_changed(self.nm.State)

    def state_changed(self, state):
        """
        Actually draw the status item, reflecting the new state of the primary
        connection along with any "extra" connections that we're currently
        interested in.
        """
        color = COLOR_BAD
        icon = type_icon('disconnected')
        text = ''

        if state in (
            NM_STATE_UNKNOWN,
            NM_STATE_ASLEEP,
            NM_STATE_DISCONNECTED,
            NM_STATE_DISCONNECTING,
        ):
            pass
        else:
            connection = self.get(self.nm.PrimaryConnection)
            icon = type_icon(connection.Type)

            # The SpecificObject has a different interface based on the
            # connection type. If it's wifi, it'll have an ssid. If not, we
            # won't display anything. The ssid is an array of bytes (yay).
            try:
                specific_object = self.get(connection.SpecificObject)
                ssid = dbus_bytes_to_str(getattr(specific_object, 'Ssid', []))
            except KeyError:
                # I've seen NM get into a state where the SpecificObject
                # reported doesn't actually exist. No reason to crash.
                ssid = '?'

            if state in (NM_STATE_CONNECTING, NM_STATE_CONNECTED_LOCAL):
                color = COLOR_WARN
                text = "…"
            elif state in (NM_STATE_CONNECTED_SITE, NM_STATE_CONNECTED_GLOBAL):
                color = COLOR_FINE
                text = ssid
            else:
                raise ValueError("Incorrect NM_STATE")

        full_text = f"{icon}{' ' if text else ''}{text}"

        for connection in self.extra:
            # Prepend each connection, since bar item priority decreases to
            # the left.
            full_text = (
                f"{type_icon(connection.Type)} {connection.Id}  " +
                full_text
            )

        print(
            json.dumps({
                'full_text': full_text,
                'color': color,
            }, ensure_ascii=False),
            flush=True,
        )
        time.sleep(1)  # Rate-limit changes so they look nicer.


def main():
    status = NetworkStatus()
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
