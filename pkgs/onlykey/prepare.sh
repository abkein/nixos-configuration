#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash git nodejs_20 gcc python3 nwjs node2nix cacert

set -euo pipefail

git clone https://github.com/abkein/OnlyKey-App
cd OnlyKey-App
node2nix -i package.json -l package-lock.json
cd -
cp OnlyKey-App/default.nix ./
cp OnlyKey-App/node-packages.nix ./
cp OnlyKey-App/node-env.nix ./
# rm -rf OnlyKey-App