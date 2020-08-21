#!/usr/bin/env python
from collections import defaultdict
from dataclasses import dataclass
import json
import sys

import gi
gi.require_version('Playerctl', '2.0')

from gi.repository import Playerctl, GLib  # noqa: E402


COLOR_FINE = '#ffffffff'
COLOR_INACTIVE = '#ffffff55'

PLAY = ' '
PAUSE = ' '
STOP = ''


def first(iterable):
    return next(iter(iterable), None)


@dataclass
class Metadata:
    status: str = STOP
    metadata: str = ''

    def __str__(self):
        if self.status == STOP:
            return self.status
        else:
            return f'{self.status} {self.metadata}'


class MediaStatus:
    def __init__(self):
        self.manager = Playerctl.PlayerManager()
        self.manager.connect('name-appeared', self.add_player)
        self.manager.connect('player-vanished', self.forget_player)

        self.cooldown = False
        self.waiting = False

        self.player_metadata = defaultdict(Metadata)
        self.player_metadata[None].status = STOP  # No players state

        for name in self.manager.props.player_names:
            self.add_player(self.manager, name)

        for player, metadata in self.player_metadata.items():
            if metadata.status == PLAY:
                self.recent_player = player
                break
        else:
            self.recent_player = None

    def add_player(self, manager, player_name):
        player = Playerctl.Player.new_from_name(player_name)
        player.connect('playback-status', self.handle_playback_status)
        player.connect('metadata', self.handle_metadata)
        self.manager.manage_player(player)
        self.handle_metadata(player)
        self.handle_playback_status(player)

    def forget_player(self, manager, player):
        del self.player_metadata[player]

        # Try to find another active player to switch back to, but we'll
        # settle for anything.
        for player, metadata in self.player_metadata.items():
            self.recent_player = player
            if metadata.status == PLAY:
                break

        self.print_status()

    def handle_playback_status(self, player, *useless_args):
        if player.props.playback_status == Playerctl.PlaybackStatus.PLAYING:
            icon = PLAY
        elif player.props.playback_status == Playerctl.PlaybackStatus.PAUSED:
            icon = PAUSE
        else:
            icon = STOP

        self.player_metadata[player].status = icon
        self.recent_player = player
        self.print_status()

    def handle_metadata(self, player, *useless_args):
        artist = player.get_artist()
        title = player.get_title() or 'Unknown Track'
        info = ' - '.join(i for i in (artist, title) if i)

        self.player_metadata[player].metadata = info
        self.recent_player = player
        self.print_status()

    def print_status(self):
        # This is elaborate in order to rate-limit updates. Sending them out
        # too quickly gets the widget stuck, so we only print at most every
        # 100 milliseconds. If updates happen faster than that, the last one
        # received will be printed after the active cooldown elapses.
        if not self.cooldown:
            print(
                json.dumps({
                    'full_text': str(self.player_metadata[self.recent_player]),
                }, ensure_ascii=False),
                flush=True
            )
            if not self.waiting:
                self.cooldown = True
                GLib.timeout_add(100, self.clear_cooldown)
        else:
            self.waiting = True

    def clear_cooldown(self):
        self.cooldown = False
        if self.waiting:
            self.print_status()
            self.waiting = False

    def toggle_mode(self):
        pass  # TODO


if __name__ == '__main__':
    status = MediaStatus()
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
