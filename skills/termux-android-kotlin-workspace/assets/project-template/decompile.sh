#!/data/data/com.termux/files/usr/bin/sh
set -eu

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
STATE_ROOT=${TERMUX_ANDROID_KOTLIN_HOME:-/data/data/com.termux/files/home/.local/share/termux-android-kotlin}
JAVA_HOME=${JAVA_HOME:-/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk}
APKTOOL_JAR=${APKTOOL_JAR:-"$STATE_ROOT/apktool.jar"}
APK_PATH=${1:-"$PROJECT_ROOT/build/app-debug.apk"}
OUTPUT_ROOT=${2:-"$PROJECT_ROOT/decompiled/$(basename "$APK_PATH" .apk)"}
JADX_OUT="$OUTPUT_ROOT/jadx"
APKTOOL_OUT="$OUTPUT_ROOT/apktool"
META_OUT="$OUTPUT_ROOT/meta"

if [ ! -f "$APK_PATH" ]; then
  echo "APK not found: $APK_PATH"
  exit 1
fi

if ! command -v jadx >/dev/null 2>&1; then
  echo "jadx is not installed."
  echo "Run sh ./scripts/setup-re-tools.sh first."
  exit 1
fi

export JAVA_HOME
export PATH="$JAVA_HOME/bin:/data/data/com.termux/files/usr/bin:$PATH"

rm -rf "$OUTPUT_ROOT"
mkdir -p "$JADX_OUT" "$META_OUT"

capture_or_note() {
  OUTPUT_FILE=$1
  shift

  if "$@" >"$OUTPUT_FILE" 2>"$OUTPUT_FILE.stderr"; then
    rm -f "$OUTPUT_FILE.stderr"
  else
    {
      echo "Command failed:"
      printf '%s ' "$@"
      echo
      echo
      cat "$OUTPUT_FILE.stderr"
    } > "$OUTPUT_FILE"
  fi
}

capture_or_note "$META_OUT/badging.txt" aapt dump badging "$APK_PATH"
capture_or_note "$META_OUT/permissions.txt" aapt dump permissions "$APK_PATH"
capture_or_note "$META_OUT/manifest-xmltree.txt" aapt dump xmltree "$APK_PATH" AndroidManifest.xml
capture_or_note "$META_OUT/archive-files.txt" unzip -l "$APK_PATH"

set +e
jadx -d "$JADX_OUT" "$APK_PATH"
JADX_STATUS=$?
set -e

if [ "$JADX_STATUS" -ne 0 ]; then
  if [ "$JADX_STATUS" -eq 3 ] && [ -d "$JADX_OUT/sources" ]; then
    echo "jadx completed with partial decompilation errors; exported sources were kept."
  else
    exit "$JADX_STATUS"
  fi
fi

if [ -f "$APKTOOL_JAR" ]; then
  "$JAVA_HOME/bin/java" -jar "$APKTOOL_JAR" d -f "$APK_PATH" -o "$APKTOOL_OUT"
else
  echo "apktool.jar not found, skipped smali/resources decode."
fi

echo "JADX output: $JADX_OUT"
if [ -d "$APKTOOL_OUT" ]; then
  echo "Apktool output: $APKTOOL_OUT"
fi
echo "Metadata output: $META_OUT"
