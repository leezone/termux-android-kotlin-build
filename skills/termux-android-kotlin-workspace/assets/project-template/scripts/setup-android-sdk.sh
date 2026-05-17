#!/data/data/com.termux/files/usr/bin/sh
set -eu

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
STATE_ROOT=${TERMUX_ANDROID_KOTLIN_HOME:-/data/data/com.termux/files/home/.local/share/termux-android-kotlin}
SDK_ROOT=${ANDROID_HOME:-$STATE_ROOT/sdk}
DOWNLOAD_DIR="$STATE_ROOT/downloads"
JAVA_HOME=${JAVA_HOME:-/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk}
CMDLINE_URL=${CMDLINE_URL:-https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip}
CMDLINE_ZIP="$DOWNLOAD_DIR/commandlinetools-linux-14742923_latest.zip"
SDKMANAGER="$SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"

copy_existing_platform() {
  for CANDIDATE in \
    "$PROJECT_ROOT/android-sdk" \
    /data/data/com.termux/files/usr/tmp/termux-android-sdk
  do
    if [ -f "$CANDIDATE/platforms/android-34/android.jar" ]; then
      mkdir -p "$SDK_ROOT/platforms"
      cp -a "$CANDIDATE/platforms/android-34" "$SDK_ROOT/platforms/"
      return 0
    fi
  done
  return 1
}

mkdir -p "$SDK_ROOT" "$DOWNLOAD_DIR" "$SDK_ROOT/cmdline-tools/latest"
export JAVA_HOME
export PATH="$JAVA_HOME/bin:/data/data/com.termux/files/usr/bin:$PATH"

if [ ! -f "$CMDLINE_ZIP" ]; then
  curl -L --fail --retry 5 --retry-all-errors -o "$CMDLINE_ZIP" "$CMDLINE_URL"
fi

if [ ! -f "$SDKMANAGER" ]; then
  unzip -q "$CMDLINE_ZIP" -d "$SDK_ROOT/cmdline-tools"
  cp -a "$SDK_ROOT/cmdline-tools/cmdline-tools/." "$SDK_ROOT/cmdline-tools/latest/"
fi

sh -c "yes | env JAVA_HOME=$JAVA_HOME PATH=$PATH sh $SDKMANAGER --sdk_root=$SDK_ROOT --licenses"

set +e
env JAVA_HOME="$JAVA_HOME" PATH="$PATH" sh "$SDKMANAGER" --sdk_root="$SDK_ROOT" "platforms;android-34"
SDKMANAGER_STATUS=$?
set -e

if [ "$SDKMANAGER_STATUS" -ne 0 ] && [ ! -f "$SDK_ROOT/platforms/android-34/android.jar" ]; then
  if copy_existing_platform; then
    echo "Copied android-34 platform from an existing local SDK."
  else
    echo "Failed to install android-34 and no fallback SDK was found."
    exit "$SDKMANAGER_STATUS"
  fi
fi

echo "Android SDK ready at $SDK_ROOT"
