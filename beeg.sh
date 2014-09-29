#!/bin/bash

function urldecode() {
    perl -pe 's/%([0-9a-f]{2})/sprintf("%s", pack("H2",$1))/eig'
}

function silentmp () {
    mpv --no-terminal $1
}
}

function beegURL()  {
    curl -s $1 | grep -Po "(?<='file': ').*(?=')"
}

function xvideos_url () {
    curl -s $1 | grep -Po "(?<=flv_url=)[^;]*(?=&amp;)" | urldecode
}

function xpl() {
    silentmp `xvideos_url $1`
}

function bpl() {
    silentmp `beegURL $1` &
}

function bpl2 () {
    mplayer2  `beegURL $1`
}

# If run with arguments, try to execute the arguments as functions.
# see anime.sh
if [ ! -z "$*" ]
then
    command=$1
    shift
    $command $*
fi
