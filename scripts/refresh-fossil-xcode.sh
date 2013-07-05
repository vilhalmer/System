#!/usr/bin/env zsh
# This script is designed to be used in conjunction with Xcode Behaviors.

tmux send-keys -t "fossil:1" " clear && cd -q $XcodeWorkspacePath/../.. && ffsl" Enter
