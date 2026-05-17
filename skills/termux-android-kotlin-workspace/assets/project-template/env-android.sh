#!/data/data/com.termux/files/usr/bin/sh

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
STATE_ROOT=${TERMUX_ANDROID_KOTLIN_HOME:-/data/data/com.termux/files/home/.local/share/termux-android-kotlin}

export JAVA_HOME=/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk
export ANDROID_HOME=${ANDROID_HOME:-$STATE_ROOT/sdk}
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_API=34
export KOTLIN_HOME=/data/data/com.termux/files/usr/opt/kotlin
export KOTLIN_LIB_DIR="$KOTLIN_HOME/lib"
export APKTOOL_JAR=${APKTOOL_JAR:-$STATE_ROOT/apktool.jar}
export PATH="$JAVA_HOME/bin:/data/data/com.termux/files/usr/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

echo "JAVA_HOME=$JAVA_HOME"
echo "ANDROID_HOME=$ANDROID_HOME"
echo "ANDROID_API=$ANDROID_API"
echo "KOTLIN_LIB_DIR=$KOTLIN_LIB_DIR"
echo "APKTOOL_JAR=$APKTOOL_JAR"
