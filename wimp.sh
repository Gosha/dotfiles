#!/bin/bash

function randomWimpOrgURL () {
    curl -Is www.wimp.com/random | grep -Po '(?<=Location: ).*/'
}

function wimpOrgFile() {
    curl $1 -Ls | grep "var googleCode"  | sed "s/.*'\(.*\)';/\1/" | base64 -d | grep -Po '(http://.*)(?="\))'
}

function wmp() {
    smplayer -close-at-end `wimpOrgFile $1`
}

function rwmp() {
    URL=`randomWimpOrgURL`
    echo $URL
    wmp $URL
}
