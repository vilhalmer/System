# Dotfiles and Dotfile Accessories

## What is?
This is where I keep my configuration for (nearly) everything. Eventually I hope to get rid of the (nearly), but some software is just not very cooperative.

I use this configuration nearly exclusively on OS X, but I do have it on a few Linux servers.

## How do?
If you want to use these dotfiles, I'd recommend forking the repo and making any changes that you would like, first.
If you do want to install this as-is, it's as easy as:
```
cd ~ # (or wherever you would like to keep it)
git clone https://github.com/vilhalmer/System
System/sys-manage link
```

This will symlink everything into place, renaming any existing dotfiles with .back to preserve them. See the section on `sys-manage` below for more stuff it can do.

## What's included?
### .profile
Used to set up stuff that should exist across shells. Of interest:
- I use the XDG directory spec to keep my home directory as clean as possible.
    - $XDG_CONFIG_HOME is ~/.config
    - $XDG_DATA_HOME is ~/.local/share
    - $XDG_CACHE_HOME is ~/.cache
- $VIMINIT
    - A mess to allow vim and neovim to play nicely together.
- profile.d
    - The profile will source any scripts stored in $XDG_CONFIG_HOME/profile.d/ as the last thing it does. This directory is specifically excluded from this repo to allow it to be used for machine-specific stuff.

### zsh
My shell of choice. There's a lot of stuff in this, but the majority of it is passive.
- I have a pretty fancy custom prompt, which is aware of git repositories.
    - It also supports right-aligned widgets on the first line. I'm not currently using this feature, but it's pretty cool.
- Completions are enabled, I have no idea how they work.
- When running in a tmux, the window will be automatically renamed when in a git repository.
- ls output is colored, but is in need of a revamp.
- Homebrew update checker (where applicable)
    - Every day (past 5 AM), opening a new shell will run `brew update`, and display any available updates in a nice format. This tends to take a while, so it is rate-limited to once a day.
    - The list of updates will persist on new shells (but not every prompt) as long as there are still updates to be installed.
    - Pinned formulae are not included in the list.

Handy functions:
- `configure`: Takes the trailing part of a path, and attempts to locate a matching file in $XDG_CONFIG_HOME, then $HOME. If it finds any matches, it opens the first file in $EDITOR.
    - For example, you can edit ~/.config/git/config by typing `configure git/config`.
- `yank`: Copies the last command you ran to the clipboard. You can also give it a number, and it will copy the Nth-last command.

### neovim <3
…there is a lot. It's probably best to just check out init.vim.

### tmux
My tmux configuration generally assumes that you're on whatever version is latest in Homebrew. It tends to be a bit broken on older versions, but mostly works. They keep making breaking changes to options, so there isn't a lot I can do about this.

- My prefix is C-q, but changes occasionally because I'm never happy with it.
- Most of the keybindings are non-default, so you'll want to check out tmux.conf for the latest set.
- I have vim-tmux-navigator installed, so you can use Control + vim directions to navigate both tmux and (n)vim splits.
- On OS X, the statusline contains a battery indicator. I'd like to get this working on Linux eventually as well. It currently doesn't check to see if the system actually HAS a battery, so you may have to kill it with fire on desktop machines.

### git
Originally, this repo contained my git [user] section. After several incidents with people using this config and committing things as me (read the config, dammit), I removed it. It should be placed in ~/.gitconfig instead, which is not included in the repo. Anything in that file overrides anything in $XDG_CONFIG_HOME.
- I use `push.default = simple`.

### Later This Evening
I use a custom-designed, one-of-a-kind bespoke (sorry) color scheme that I derived from Tomorrow Night Eighties, called Later This Evening. There are Terminal.app and iTerm 2 versions included, and you are likely to find that some stuff is unreadable if you don't use them. Some of the mappings are… strange. I've been slowly working to fix this, since I do occasionally use my config in places where I can't install them, but it's not a high priority.
If I ever start using a Linux terminal on a regular basis, I'll add a version for it as well.

## sys-manage
`sys-manage` is the primary way to interact with my configuration. It's in need of a bit of cleanup, but works fairly well. Here are the commands it supports:

- Commonly-used commands:
    - **link**: Symlinks configuration from dotfiles/ into place. All bare files are assumed to go in ~/.$filename, all subdirectories are put in $XDG_CONFIG_HOME. This isn't a good enough heuristic to cover all software, but works well enough for the moment.
    - **configure**: Performs one-time setup type commands, like setting the user's shell. In fact, that's all it does for the moment.
    - **install**: Installs a set of software, choosing the package manager based on which operating system we're running. The newest addition, **probably still a bit buggy**.
        - OS X: Ensures that the Xcode command line tools and Homebrew are installed, then installs any software specified in ~/.Brewfile. A Brewfile is not yet included in the repo and should be dropped in if you want this command to do anything.
        - *Other systems to come as I have a need for them.*
- Other commands:
    - **revert**: Unlinks everything, and restores any .back files that **link** created.
    - **import**: Adds the specified dotfiles to the repository and links them back to their original location. I usually just do this manually, so this doesn't get a lot of testing. It may be removed in the future.
    - **pull**: An alias for `git pull origin master`. I'm in the middle of expanding its functionality to including automatic rebasing when other branches are checked out, to allow for the creation of machine-specific branches.

## Wrap-up
Feel free to open issues, and I will try to fix them if I have a way to reproduce them. I like to know when things are broken, because I'm likely to run into the same problem eventually (if I haven't already).

That's it for now. I hope you found something useful! 

