#!/bin/bash
function ymp() {
    smplayer -add-to-playlist `youtube-dl -g --max-quality 22 $1`;
}
