function cpw() { # Copy to web
    scp $1 besvikel.se:/var/www/liten.besvikel.se/$2/
    echo -n "http://liten.besvikel.se/$2/`basename $1`" | xclip
}
function cpwi() { # copy to img
    cpw $1 img
}
