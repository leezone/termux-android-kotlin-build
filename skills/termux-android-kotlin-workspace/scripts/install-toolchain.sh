#!/data/data/com.termux/files/usr/bin/sh
set -eu

STATE_ROOT=${TERMUX_ANDROID_KOTLIN_HOME:-/data/data/com.termux/files/home/.local/share/termux-android-kotlin}
SDK_ROOT=${ANDROID_HOME:-$STATE_ROOT/sdk}
DOWNLOAD_DIR="$STATE_ROOT/downloads"
JAVA_HOME=${JAVA_HOME:-/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk}
CMDLINE_URL=${CMDLINE_URL:-https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip}
CMDLINE_ZIP="$DOWNLOAD_DIR/commandlinetools-linux-14742923_latest.zip"
SDKMANAGER="$SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"
REQUESTED_APIS=${*:-34}
PLATFORM_SRC_ROOTS=${ANDROID_PLATFORM_SRC:-}
SDKMANAGER_PROXY_TYPE=${SDKMANAGER_PROXY_TYPE:-}
SDKMANAGER_PROXY_HOST=${SDKMANAGER_PROXY_HOST:-}
SDKMANAGER_PROXY_PORT=${SDKMANAGER_PROXY_PORT:-}

copy_existing_platform() {
  API_LEVEL=$1
  for CANDIDATE in \
    /data/data/com.termux/files/usr/tmp/termux-android-sdk \
    "$STATE_ROOT/sdk"
  do
    if [ -f "$CANDIDATE/platforms/android-$API_LEVEL/android.jar" ]; then
      mkdir -p "$SDK_ROOT/platforms"
      cp -a "$CANDIDATE/platforms/android-$API_LEVEL" "$SDK_ROOT/platforms/"
      return 0
    fi
  done

  if [ -n "$PLATFORM_SRC_ROOTS" ]; then
    OLD_IFS=$IFS
    IFS=:
    for CANDIDATE in $PLATFORM_SRC_ROOTS; do
      if [ -f "$CANDIDATE/platforms/android-$API_LEVEL/android.jar" ]; then
        mkdir -p "$SDK_ROOT/platforms"
        cp -a "$CANDIDATE/platforms/android-$API_LEVEL" "$SDK_ROOT/platforms/"
        IFS=$OLD_IFS
        return 0
      fi
      if [ -f "$CANDIDATE/android.jar" ] && printf '%s' "$CANDIDATE" | grep -q "/android-$API_LEVEL$"; then
        mkdir -p "$SDK_ROOT/platforms"
        cp -a "$CANDIDATE" "$SDK_ROOT/platforms/"
        IFS=$OLD_IFS
        return 0
      fi
    done
    IFS=$OLD_IFS
  fi

  return 1
}

run_sdkmanager() {
  set -- --sdk_root="$SDK_ROOT" "$@"

  if [ -n "$SDKMANAGER_PROXY_TYPE" ] && [ -n "$SDKMANAGER_PROXY_HOST" ] && [ -n "$SDKMANAGER_PROXY_PORT" ]; then
    set -- \
      --proxy="$SDKMANAGER_PROXY_TYPE" \
      --proxy_host="$SDKMANAGER_PROXY_HOST" \
      --proxy_port="$SDKMANAGER_PROXY_PORT" \
      "$@"
  fi

  env JAVA_HOME="$JAVA_HOME" PATH="$PATH" sh "$SDKMANAGER" "$@"
}

pkg install -y openjdk-17 gradle kotlin android-tools aapt aapt2 apksigner d8 unzip

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

yes | run_sdkmanager --licenses
for API_LEVEL in $REQUESTED_APIS; do
  set +e
  run_sdkmanager "platforms;android-$API_LEVEL"
  SDKMANAGER_STATUS=$?
  set -e

  if [ "$SDKMANAGER_STATUS" -ne 0 ] && [ ! -f "$SDK_ROOT/platforms/android-$API_LEVEL/android.jar" ]; then
    if copy_existing_platform "$API_LEVEL"; then
      echo "Copied android-$API_LEVEL platform from an existing local SDK."
    else
      echo "Failed to install android-$API_LEVEL and no fallback SDK was found."
      exit "$SDKMANAGER_STATUS"
    fi
  fi
done

echo "Toolchain ready."
echo "ANDROID_HOME=$SDK_ROOT"
