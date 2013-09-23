#!/bin/bash

function silentmp () {
    mplayer2  -msglevel all=0 -noconsolecontrols $1
}

function beegURL()  {
    curl -s $1 | grep -Po "(?<='file': ').*(?=')"
}

function bpl() {
    silentmp `beegURL $1`
}

function bpl2 () {
    mplayer2  `beegURL $1`
}
