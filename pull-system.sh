#!/usr/bin/env zsh
# Look, another lazy script!

DIR="$( cd "$( dirname "$0" )" && pwd )"

cd $DIR
echo "Pulling latest System configuration..."
git pull origin master
