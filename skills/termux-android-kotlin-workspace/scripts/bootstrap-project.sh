#!/data/data/com.termux/files/usr/bin/sh
set -eu

SKILL_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

sh "$SKILL_ROOT/scripts/install-toolchain.sh"
sh "$SKILL_ROOT/scripts/install-re-tools.sh"
sh "$SKILL_ROOT/scripts/init-project.sh" "$@"
