#!/usr/bin/env bash

set -euo pipefail

_get() {
  local repository="$1"
  local branch="$2"
  local remote="$3"
  cd "${repository}"
  git fetch "${remote}"
  git switch "${branch}"
  git merge --ff-only "${remote}/${branch}"
}

pull() {
  local repository="$1"
  local branch="$2"
  local remote="$3"
  echo "Pulling ${repository}"
  _get "${repository}" "${branch}" "${remote}"
  cd -
}

sync() {
  local repository="$1"
  local branch="$2"
  local remote="$3"
  local target_remote="$4"
  echo "Syncing ${repository}"
  _get "${repository}" "${branch}" "${remote}"
  git push "${target_remote}" "${branch}"
  cd -
}

sync /home/kein/repos/nixpkgs master upstream origin
sync /home/kein/repos/home-manager master upstream origin
sync /home/kein/repos/stylix master upstream origin

pull /home/kein/repos/linux master origin
pull /home/kein/repos/nix master origin
