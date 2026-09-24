dotfiles
========

Usage based on this: https://www.atlassian.com/git/tutorials/dotfiles / https://bitbucket.org/durdn/cfg/src/master/

Quick setup: `curl -Lks https://raw.githubusercontent.com/Gosha/dotfiles/master/.dotfiles-aux/setup.sh | /bin/bash`

See: [setup.hs](.dotfiles-aux/setup.sh)

Smarter Ctrl-W in bash (see [smartword.c](.dotfiles-aux/smartword/smartword.c)): home-manager builds it on Nix machines; elsewhere run `make -C ~/.dotfiles-aux/smartword install` once.
