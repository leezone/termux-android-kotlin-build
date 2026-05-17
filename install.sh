#!/data/data/com.termux/files/usr/bin/sh
set -eu

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
APK_PATH=${1:-"$PROJECT_ROOT/build/app-debug.apk"}

if [ ! -f "$APK_PATH" ]; then
  echo "APK not found: $APK_PATH"
  echo "Run ./build.sh first."
  exit 1
fi

termux-open --content-type application/vnd.android.package-archive "$APK_PATH"
echo "Installer opened for $APK_PATH"
