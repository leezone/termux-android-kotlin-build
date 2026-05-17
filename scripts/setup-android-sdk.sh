#!/data/data/com.termux/files/usr/bin/sh
set -eu

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SDK_ROOT=${ANDROID_HOME:-/data/data/com.termux/files/usr/tmp/termux-android-sdk}
DOWNLOAD_DIR="$PROJECT_ROOT/.downloads"
JAVA_HOME=${JAVA_HOME:-/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk}
CMDLINE_URL=${CMDLINE_URL:-https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip}
CMDLINE_ZIP="$DOWNLOAD_DIR/commandlinetools-linux-14742923_latest.zip"
SDKMANAGER="$SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"

mkdir -p "$SDK_ROOT" "$DOWNLOAD_DIR" "$SDK_ROOT/cmdline-tools/latest"
export JAVA_HOME
export PATH="$JAVA_HOME/bin:/data/data/com.termux/files/usr/bin:$PATH"

if [ ! -f "$CMDLINE_ZIP" ]; then
  curl -L --fail -o "$CMDLINE_ZIP" "$CMDLINE_URL"
fi

if [ ! -f "$SDKMANAGER" ]; then
  unzip -q "$CMDLINE_ZIP" -d "$SDK_ROOT/cmdline-tools"
  cp -a "$SDK_ROOT/cmdline-tools/cmdline-tools/." "$SDK_ROOT/cmdline-tools/latest/"
fi

sh -c "yes | env JAVA_HOME=$JAVA_HOME PATH=$PATH sh $SDKMANAGER --sdk_root=$SDK_ROOT --licenses"
env JAVA_HOME="$JAVA_HOME" PATH="$PATH" sh "$SDKMANAGER" --sdk_root="$SDK_ROOT" "platforms;android-34"

echo "Android SDK ready at $SDK_ROOT"
