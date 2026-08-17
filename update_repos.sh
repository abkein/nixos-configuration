#!/usr/bin/env bash

set -euo pipefail

sync() {
    echo "Syncing $1"
    cd $1
    git fetch upstream
    git switch $2
    git merge --ff-only upstream/$2
    git push origin $2
    cd -
}

sync /home/kein/repos/nixpkgs master
sync /home/kein/repos/home-manager master
sync /home/kein/repos/stylix master

