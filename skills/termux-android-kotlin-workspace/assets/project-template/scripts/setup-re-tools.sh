#!/data/data/com.termux/files/usr/bin/sh
set -eu

STATE_ROOT=${TERMUX_ANDROID_KOTLIN_HOME:-/data/data/com.termux/files/home/.local/share/termux-android-kotlin}
JAVA_HOME=${JAVA_HOME:-/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk}
APKTOOL_VERSION=${APKTOOL_VERSION:-3.0.2}
APKTOOL_JAR="$STATE_ROOT/apktool_${APKTOOL_VERSION}.jar"
APKTOOL_LINK="$STATE_ROOT/apktool.jar"
APKTOOL_URL=${APKTOOL_URL:-"https://github.com/iBotPeaches/Apktool/releases/download/v${APKTOOL_VERSION}/apktool_${APKTOOL_VERSION}.jar"}

export JAVA_HOME
export PATH="$JAVA_HOME/bin:/data/data/com.termux/files/usr/bin:$PATH"

pkg install -y jadx
mkdir -p "$STATE_ROOT"

if [ ! -f "$APKTOOL_JAR" ]; then
  curl -L --fail --retry 5 --retry-all-errors -o "$APKTOOL_JAR" "$APKTOOL_URL"
fi

cp -f "$APKTOOL_JAR" "$APKTOOL_LINK"

jadx --version
"$JAVA_HOME/bin/java" -jar "$APKTOOL_LINK" --version

echo "JADX and Apktool are ready."
echo "APKTOOL_JAR=$APKTOOL_LINK"
