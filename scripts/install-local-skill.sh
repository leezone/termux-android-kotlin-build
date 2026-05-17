#!/data/data/com.termux/files/usr/bin/sh
set -eu

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SKILL_NAME=termux-android-kotlin-workspace
SOURCE_DIR="$PROJECT_ROOT/skills/$SKILL_NAME"
TARGET_ROOT=${CODEX_HOME:-/data/data/com.termux/files/home/.codex}
TARGET_DIR="$TARGET_ROOT/skills/$SKILL_NAME"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Skill source not found: $SOURCE_DIR"
  exit 1
fi

mkdir -p "$TARGET_ROOT/skills"
rm -rf "$TARGET_DIR"
cp -a "$SOURCE_DIR" "$TARGET_DIR"

echo "Installed skill to $TARGET_DIR"
