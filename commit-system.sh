#!/usr/bin/env zsh
# This is probably a really bad idea, but whatevers dawg. I'm lazy.

if [[ -z $1 ]]; then
    echo "You probably want a commit message on there."
    exit 1
fi

DIR="$( cd "$( dirname "$0" )" && pwd )"

cd $DIR
git status
echo
echo "Commit message: $1"

echo "So, everything look good?"
while true; do
    read yn 
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo "Committing and pushing..."

git add -A && git commit -m "$1" && git push origin master
