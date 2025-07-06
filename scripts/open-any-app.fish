#!/usr/bin/env fish

set -l app (nix search nixpkgs --json ^ | jq -r 'keys[]' | sed 's/^legacyPackages\.[^.]*\.//' | rofi -dmenu)
NIXPKGS_ALLOW_UNFREE=1 nix-shell --impure -p $app --command "uwsm app -- $app"
