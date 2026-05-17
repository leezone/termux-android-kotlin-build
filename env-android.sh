#!/data/data/com.termux/files/usr/bin/sh

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

export JAVA_HOME=/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk
export ANDROID_HOME=/data/data/com.termux/files/usr/tmp/termux-android-sdk
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_API=34
export KOTLIN_HOME=/data/data/com.termux/files/usr/opt/kotlin
export KOTLIN_LIB_DIR="$KOTLIN_HOME/lib"
export APKTOOL_JAR="$PROJECT_ROOT/tools/apktool.jar"
export PATH="$JAVA_HOME/bin:/data/data/com.termux/files/usr/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

echo "JAVA_HOME=$JAVA_HOME"
echo "ANDROID_HOME=$ANDROID_HOME"
echo "ANDROID_API=$ANDROID_API"
echo "KOTLIN_LIB_DIR=$KOTLIN_LIB_DIR"
