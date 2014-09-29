#!/bin/bash
# Copy to ~root, because this script is run as root.
contains() {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

devicevalfromkey() {
    local index
    for index in ${!device_keys[*]}
    do
        if [[ "${device_keys[$index]}" == "$1" ]]
        then
            echo "${device_vals[$index]}"
            return 0
        fi
    done
    return 1
}

echo -n "xrandr: "
if ! which xrandr
then
    exit 1
fi

XRANDR_QUERY=$(xrandr -q)

device_keys=( laptop extra_screen )
device_vals=( LVDS1  VGA1 )

connected_screens=()

for index in ${!device_keys[*]}
do
    grep -q "${device_keys_names[$index]} connected" <<< "${XRANDR_QUERY}" &&\
       connected_screens=(${connected_screens[*]} ${device_keys[$index]})
done

#echo "${XRANDR_QUERY}"
#echo ${connected_screens[*]}

if contains laptop ${connected_screens[*]} &&
    contains extra_screen ${connected_screens[*]}
then
    xrandr --output $(devicevalfromkey extra_screen) --primary
    xrandr --output  $(devicevalfromkey laptop) \
           --left-of $(devicevalfromkey extra_screen)
fi
