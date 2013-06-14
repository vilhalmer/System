# System Repo #
This repository is where I keep all of my configuration files, custom scripts, and terminal themes. It also includes the sys-manage script, which allows me to push and pull changes, link and unlink the dotfiles, and do basic automatic system setup. This allows for extremely quick configuration of new systems.

Also a useful part of the quick-configuration pipeline is my `setup` script, a copy of which is included in the scripts directory. It lives at config.unsquared.co, allowing me to pull down a copy of this repository in a single line: `curl -sLA '' config.unsquared.co | sh`. It isn't really necessary at the moment, since it only does one thing, but I plan to add more to it in the future. (The `-A ''` bit is necessary because my host blocks curl requests. Sending an empty user-agent is fine, though. `-sL` just makes it shut up about download progress and follow any redirects that I might put in place in the future.)

Enjoy!
