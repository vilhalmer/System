#!/usr/bin/env bash
# how-formed is a script that allows aliasing `man $whatever` to `how $whatever formed` for the lulz.
# Intended usage: alias `how` to this script, it will take care of the rest.
# If you want it to be strict, make the alias `how --strict`, and it will ensure that "formed" is the last argument.

strict=1
if [ "$1" == "--strict" ]; then
    strict=0
    shift
fi

arguments=("$@") # Arrays ftw

formed=1
if [[ ${#arguments[@]} -gt 0 ]] && [[ "${arguments[${#arguments[@]}-1]}" == "formed" ]]; then
    formed=0
    unset arguments[${#arguments[@]}-1]
fi

if [[ $strict -eq 0 ]] && [[ $formed -eq 1 ]]; then
    echo "malformed"
    exit 1
fi

if [[ ${#arguments[@]} -eq 0 ]]; then
    echo "you accidentally some arguments"
    exit 1
fi

if [[ $strict -eq 0 ]] && [[ "${arguments[@]}" == "is babby" ]]; then
    echo "they need to do way instain mother"
else
    man ${arguments} 2>/dev/null || ( echo "what is this i don't even"; exit 1 )
fi
