#!/data/data/com.termux/files/usr/bin/sh
set -eu

SKILL_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

COMPILE_API=${4:-34}
EXTRA_APIS=
if [ $# -ge 7 ]; then
  shift 6
  EXTRA_APIS="$*"
fi

if [ -n "$EXTRA_APIS" ]; then
  sh "$SKILL_ROOT/scripts/install-toolchain.sh" "$COMPILE_API" "$EXTRA_APIS"
else
  sh "$SKILL_ROOT/scripts/install-toolchain.sh" "$COMPILE_API"
fi
sh "$SKILL_ROOT/scripts/install-re-tools.sh"
sh "$SKILL_ROOT/scripts/init-project.sh" "$@"
