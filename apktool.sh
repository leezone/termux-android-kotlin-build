#!/data/data/com.termux/files/usr/bin/sh
set -eu

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
JAVA_HOME=${JAVA_HOME:-/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk}
APKTOOL_JAR=${APKTOOL_JAR:-"$PROJECT_ROOT/tools/apktool.jar"}

if [ ! -f "$APKTOOL_JAR" ]; then
  echo "Missing $APKTOOL_JAR"
  echo "Run sh ./scripts/setup-re-tools.sh first."
  exit 1
fi

exec "$JAVA_HOME/bin/java" -jar "$APKTOOL_JAR" "$@"
