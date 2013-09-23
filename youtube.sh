#!/bin/bash
function ymp() {
    smplayer -add-to-playlist `youtube-dl -g --max-quality 22 $1`;
}

# If run with arguments, try to execute the arguments as functions.
# see anime.sh
if [ ! -z "$*" ]
then
    command=$1
    shift
    $command $*
fi
