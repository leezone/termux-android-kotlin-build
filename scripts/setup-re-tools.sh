#!/data/data/com.termux/files/usr/bin/sh
set -eu

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TOOLS_DIR="$PROJECT_ROOT/tools"
JAVA_HOME=${JAVA_HOME:-/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk}
APKTOOL_VERSION=${APKTOOL_VERSION:-3.0.2}
APKTOOL_JAR="$TOOLS_DIR/apktool_${APKTOOL_VERSION}.jar"
APKTOOL_LINK="$TOOLS_DIR/apktool.jar"
APKTOOL_URL=${APKTOOL_URL:-"https://github.com/iBotPeaches/Apktool/releases/download/v${APKTOOL_VERSION}/apktool_${APKTOOL_VERSION}.jar"}

export JAVA_HOME
export PATH="$JAVA_HOME/bin:/data/data/com.termux/files/usr/bin:$PATH"

pkg install -y jadx
mkdir -p "$TOOLS_DIR"

if [ ! -f "$APKTOOL_JAR" ]; then
  curl -L --fail --retry 5 --retry-all-errors -o "$APKTOOL_JAR" "$APKTOOL_URL"
fi

cp -f "$APKTOOL_JAR" "$APKTOOL_LINK"

jadx --version
"$JAVA_HOME/bin/java" -jar "$APKTOOL_LINK" --version

echo "JADX and Apktool are ready."
echo "APKTOOL_JAR=$APKTOOL_LINK"
