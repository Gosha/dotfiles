#!/bin/bash
# Gitpod-specific bootstrap

(
    cat ./.profile
    sed 's/.*\.profile.*//' ./.bashrc
) > ~/.bashrc.d/10-private
