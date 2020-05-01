# My less-terrible notification script for weechat.
# Future enhancement: stop calling notify-send, use a library. Need to get
# weechat's event loop to cooperate with dbus.
import weechat


def handle_msg(data, pbuffer, date, tags, displayed, highlight, prefix, message):
    if weechat.buffer_get_string(pbuffer, 'localvar_away'):
        return weechat.WEECHAT_RC_OK

    tags = tags.split(',')
    try:
        notify_level = [tag for tag in tags if tag.startswith('notify_')][0]
    except IndexError:
        return weechat.WEECHAT_RC_OK  # Unknown level, assume not notifying.

    if notify_level == 'notify_none':
        return weechat.WEECHAT_RC_OK

    buffer_name = weechat.buffer_get_string(pbuffer, 'short_name')
    message_nick = [tag for tag in tags if tag.startswith('nick_')][0].split('_')[1]

    if notify_level == 'notify_message' and highlight:
        notify_user(buffer_name, f'{message_nick}: {message}')

    elif notify_level == 'notify_private':
        notify_user(buffer_name, message)

    return weechat.WEECHAT_RC_OK


def process_cb(data, command, return_code, out, err):
    if return_code == weechat.WEECHAT_HOOK_PROCESS_ERROR:
        weechat.prnt('', f'Unable to spawn {command}')
    elif return_code != 0:
        weechat.prnt('', f'notify-send exited {return_code}')

    return weechat.WEECHAT_RC_OK


def notify_user(origin, message):
    weechat.hook_process_hashtable('notify-send', {
        'arg1': '-i', 'arg2': 'weechat',
        'arg3': '-a', 'arg4': 'WeeChat',
        'arg5': origin, 'arg6': message,
    }, 20000, 'process_cb', '')

    return weechat.WEECHAT_RC_OK


weechat.register('vnotify', 'vil', '1.0', 'lol', 'A good notification script', '', '')
weechat.hook_print('', '', '', 1, 'handle_msg', '')
