#!/bin/bash

for bg in `seq 0 256`
do
    echo -en "$bg: \033[48;5;${bg}m  "
    for fg in `seq 0 15`
    do 
        echo -en "\033[38;5;${fg}m$fg Testte "
    done
    echo "\033[0m\n"
done
