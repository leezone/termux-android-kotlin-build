#!/data/data/com.termux/files/usr/bin/sh
set -eu

SKILL_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TEMPLATE_ROOT="$SKILL_ROOT/assets/project-template"
TARGET_DIR=${1:-}
PACKAGE_NAME=${2:-}
APP_LABEL=${3:-}
COMPILE_SDK=${4:-34}
TARGET_SDK=${5:-$COMPILE_SDK}
MIN_SDK=${6:-26}

if [ -z "$TARGET_DIR" ]; then
  echo "Usage: sh init-project.sh <target-dir> [package-name] [app-label] [compile-sdk] [target-sdk] [min-sdk]"
  exit 1
fi

TARGET_DIR=$(CDPATH= cd -- "$(dirname -- "$TARGET_DIR")" 2>/dev/null && pwd)/$(basename -- "$TARGET_DIR")
TARGET_BASENAME=$(basename -- "$TARGET_DIR")

sanitize_segment() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]/_/g'
}

if [ -z "$PACKAGE_NAME" ]; then
  SAFE_SEGMENT=$(sanitize_segment "$TARGET_BASENAME")
  case "$SAFE_SEGMENT" in
    ""|[0-9]*)
      SAFE_SEGMENT="app_$SAFE_SEGMENT"
      ;;
  esac
  PACKAGE_NAME="com.example.$SAFE_SEGMENT"
fi

if [ -z "$APP_LABEL" ]; then
  APP_LABEL="$TARGET_BASENAME"
fi

PACKAGE_PATH=$(printf '%s' "$PACKAGE_NAME" | tr '.' '/')

mkdir -p "$TARGET_DIR"
mkdir -p "$TARGET_DIR/scripts"
mkdir -p "$TARGET_DIR/src/$PACKAGE_PATH"

cp "$TEMPLATE_ROOT/.gitignore" "$TARGET_DIR/.gitignore"
cp "$TEMPLATE_ROOT/build.gradle" "$TARGET_DIR/build.gradle"
cp "$TEMPLATE_ROOT/gradle.properties" "$TARGET_DIR/gradle.properties"
cp "$TEMPLATE_ROOT/build.sh" "$TARGET_DIR/build.sh"
cp "$TEMPLATE_ROOT/decompile.sh" "$TARGET_DIR/decompile.sh"
cp "$TEMPLATE_ROOT/apktool.sh" "$TARGET_DIR/apktool.sh"
cp "$TEMPLATE_ROOT/gradlew" "$TARGET_DIR/gradlew"
cp "$TEMPLATE_ROOT/gradlew.bat" "$TARGET_DIR/gradlew.bat"
cp "$TEMPLATE_ROOT/install.sh" "$TARGET_DIR/install.sh"
cp "$TEMPLATE_ROOT/scripts/setup-android-sdk.sh" "$TARGET_DIR/scripts/setup-android-sdk.sh"
cp "$TEMPLATE_ROOT/scripts/setup-re-tools.sh" "$TARGET_DIR/scripts/setup-re-tools.sh"
mkdir -p "$TARGET_DIR/gradle/wrapper"
cp "$TEMPLATE_ROOT/gradle/wrapper/gradle-wrapper.jar" "$TARGET_DIR/gradle/wrapper/gradle-wrapper.jar"
cp "$TEMPLATE_ROOT/gradle/wrapper/gradle-wrapper.properties" "$TARGET_DIR/gradle/wrapper/gradle-wrapper.properties"

sed \
  -e "s|__PROJECT_NAME__|$TARGET_BASENAME|g" \
  "$TEMPLATE_ROOT/settings.gradle" > "$TARGET_DIR/settings.gradle"

sed \
  -e "s|__PACKAGE_NAME__|$PACKAGE_NAME|g" \
  -e "s|__APP_LABEL__|$APP_LABEL|g" \
  -e "s|__COMPILE_SDK__|$COMPILE_SDK|g" \
  -e "s|__TARGET_SDK__|$TARGET_SDK|g" \
  -e "s|__MIN_SDK__|$MIN_SDK|g" \
  "$TEMPLATE_ROOT/AndroidManifest.xml" > "$TARGET_DIR/AndroidManifest.xml"

sed \
  -e "s|__PACKAGE_NAME__|$PACKAGE_NAME|g" \
  -e "s|__APP_LABEL__|$APP_LABEL|g" \
  -e "s|__COMPILE_SDK__|$COMPILE_SDK|g" \
  -e "s|__TARGET_SDK__|$TARGET_SDK|g" \
  -e "s|__MIN_SDK__|$MIN_SDK|g" \
  "$TEMPLATE_ROOT/env-android.sh" > "$TARGET_DIR/env-android.sh"

sed \
  -e "s|__PACKAGE_NAME__|$PACKAGE_NAME|g" \
  "$TEMPLATE_ROOT/launch.sh" > "$TARGET_DIR/launch.sh"

sed \
  -e "s|__PACKAGE_NAME__|$PACKAGE_NAME|g" \
  -e "s|__APP_LABEL__|$APP_LABEL|g" \
  -e "s|__COMPILE_SDK__|$COMPILE_SDK|g" \
  -e "s|__TARGET_SDK__|$TARGET_SDK|g" \
  -e "s|__MIN_SDK__|$MIN_SDK|g" \
  "$TEMPLATE_ROOT/README.md.template" > "$TARGET_DIR/README.md"

sed \
  -e "s|__PACKAGE_NAME__|$PACKAGE_NAME|g" \
  -e "s|__APP_LABEL__|$APP_LABEL|g" \
  "$TEMPLATE_ROOT/src-template/MainActivity.kt.template" > "$TARGET_DIR/src/$PACKAGE_PATH/MainActivity.kt"

echo "Initialized project at $TARGET_DIR"
echo "Package: $PACKAGE_NAME"
echo "App label: $APP_LABEL"
echo "compileSdk: $COMPILE_SDK"
echo "targetSdk: $TARGET_SDK"
echo "minSdk: $MIN_SDK"
echo "Next steps:"
echo "  cd $TARGET_DIR"
echo "  . ./env-android.sh"
echo "  sh ./scripts/setup-android-sdk.sh"
echo "  sh ./scripts/setup-re-tools.sh"
echo "  sh ./gradlew lint"
echo "  sh ./gradlew assembleDebug"
