#!/bin/bash
function aniplay() {
    # Plays a file with mplayer and marks as watched with anidb when it's done
    # If specified with --ask, zenity is used to ask whether the user wants to mark it as watched
    local ASK

    play=$1
    if [ "$1" == "--ask" ]; then
        ASK="true"
        play="$2"
    fi

    mplayer2 "$play"

    if [ "$ASK" ]; then
        zenity --question --title "Hello" --text "Mark as watched on anidb?"
        if [ $? -ne 0 ]; then
            return 0
        fi
    fi

    out="1"
    while [[ "$out" -eq "1" ]]
    do
        anidb -aw "$play"
        out=$?
        if [[ "$out" -eq "1" ]]
        then
            sleep 10
        fi
    done
}

function aplay() {
    # Tries to play an episode of an anime by searching for it with findanime
    # If there are several matches zenity is used to show a list of the matches

    list=$( findanime "$1" "$2" )
    if (( ("$?" == 0) && $((`echo "$list" | wc -l` > 1)) ))
    then
        res=$( echo "$list" | zenity --list --column "File" --width 600 --height 700 2> /dev/null )
        if [ -z "$res" ]; then
            return 1
        fi
    elif [ -z "$list" ] || [ "`echo "$list" | wc -l`" -le 0 ]; then
        echo 'Nothing found!'
        return 1
    else
        res="$list"
    fi

    aniplay --ask "$res"
}

function findanime () {
    # Creates a list of anime files in ANIME_DIRS that matches name $1 and epno $2

    ANIME_DIRS=( "/home/gosha/anime" "/media/f/Anime" )
    local res=
    local tempres=
    for dir in "${ANIME_DIRS[@]}"
    do
        if [[ -d "$dir" ]]
        then
            tempres=$( find $dir -xtype f | grep -i "$1" | grep -iP "((?<=[- _])|(?<=Ep))0*$2(?=[\[ _v.])" )
            if [ ! -z "$res" ]
            then
                res=$(echo -e "$res\n$tempres")
            else
                res="$tempres"
            fi
        fi
    done
    echo "$res"
}
