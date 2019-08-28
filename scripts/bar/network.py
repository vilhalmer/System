#!/usr/bin/env python
import array
import json
import time

import pydbus
from gi.repository import GLib


COLOR_BAD = '#f9b381aa'
COLOR_WARN = '#ffff00aa'
COLOR_FINE = '#ffffffaa'
COLOR_INACTIVE = '#888888aa'


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
    else:
        return '\uf6ff\u2009'


def main():
    bus = pydbus.SystemBus()
    nm = bus.get('.NetworkManager')

    def state_changed(state):
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
            connection = bus.get('.NetworkManager', nm.PrimaryConnection)
            icon = type_icon(connection.Type)

            # The SpecificObject has a different interface based on the
            # connection type. If it's wifi, it'll have an ssid. If not, we
            # won't display anything. The ssid is an array of bytes (yay).
            try:
                specific_object = bus.get(
                    '.NetworkManager',
                    connection.SpecificObject
                )
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

        print(
            json.dumps({
                'full_text': f"{icon}{' ' if text else ''}{text}",
                'color': color,
            }, ensure_ascii=False),
            flush=True,
        )
        time.sleep(1)  # Rate-limit changes so they look nicer.

    nm.onStateChanged = state_changed

    # Watch for NetworkManager restarts so the info doesn't remain stale until
    # it gets around to reconnecting. The arguments are incorrect, so eat them.
    bus.watch_name(
        'org.freedesktop.NetworkManager',
        name_vanished=lambda: state_changed(NM_STATE_UNKNOWN),
    )

    state_changed(nm.State)  # Trigger immediately for the current state.
    GLib.MainLoop().run()


if __name__ == '__main__':
    main()
