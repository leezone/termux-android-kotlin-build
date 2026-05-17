#!/data/data/com.termux/files/usr/bin/sh
set -eu

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SDK_ROOT=${ANDROID_HOME:-/data/data/com.termux/files/usr/tmp/termux-android-sdk}
ANDROID_API=${ANDROID_API:-34}
ANDROID_JAR="$SDK_ROOT/platforms/android-$ANDROID_API/android.jar"
KOTLIN_LIB_DIR=${KOTLIN_LIB_DIR:-/data/data/com.termux/files/usr/opt/kotlin/lib}
BUILD_DIR="$PROJECT_ROOT/build"
CLASSES_DIR="$BUILD_DIR/classes"
DEX_DIR="$BUILD_DIR/dex"
UNSIGNED_APK="$BUILD_DIR/app-unsigned.apk"
SIGNED_APK="$BUILD_DIR/app-debug.apk"
KEYSTORE="$PROJECT_ROOT/debug.keystore"
JAVA_HOME=${JAVA_HOME:-/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk}
KOTLIN_STD_JAR="$KOTLIN_LIB_DIR/kotlin-stdlib.jar"
KOTLIN_STD_JDK7_JAR="$KOTLIN_LIB_DIR/kotlin-stdlib-jdk7.jar"
KOTLIN_STD_JDK8_JAR="$KOTLIN_LIB_DIR/kotlin-stdlib-jdk8.jar"
COMPILE_CLASSPATH="$ANDROID_JAR:$KOTLIN_STD_JAR:$KOTLIN_STD_JDK7_JAR:$KOTLIN_STD_JDK8_JAR"

if [ ! -f "$ANDROID_JAR" ]; then
  echo "Missing $ANDROID_JAR"
  echo "Run sh ./scripts/setup-android-sdk.sh first."
  exit 1
fi

if [ ! -f "$KOTLIN_STD_JAR" ]; then
  echo "Missing Kotlin stdlib at $KOTLIN_STD_JAR"
  echo "Install the Termux kotlin package first."
  exit 1
fi

export JAVA_HOME
export PATH="$JAVA_HOME/bin:/data/data/com.termux/files/usr/bin:$PATH"

rm -rf "$BUILD_DIR"
mkdir -p "$CLASSES_DIR" "$DEX_DIR"

aapt2 link \
  -o "$UNSIGNED_APK" \
  --manifest "$PROJECT_ROOT/AndroidManifest.xml" \
  -I "$ANDROID_JAR" \
  --min-sdk-version 26 \
  --target-sdk-version "$ANDROID_API"

find "$PROJECT_ROOT/src" -name '*.kt' | sort > "$BUILD_DIR/kotlin_sources.txt"
find "$PROJECT_ROOT/src" -name '*.java' | sort > "$BUILD_DIR/java_sources.txt"

if [ ! -s "$BUILD_DIR/kotlin_sources.txt" ] && [ ! -s "$BUILD_DIR/java_sources.txt" ]; then
  echo "No Kotlin or Java sources found under $PROJECT_ROOT/src"
  exit 1
fi

KOTLIN_SOURCES=$(tr '\n' ' ' < "$BUILD_DIR/kotlin_sources.txt")
JAVA_SOURCES=$(tr '\n' ' ' < "$BUILD_DIR/java_sources.txt")

filter_kotlinc_stderr() {
  if [ ! -f "$1" ]; then
    return 0
  fi

  sed \
    -e '/^Failed to load native library:jansi/d' \
    -e '/^java\.lang\.UnsatisfiedLinkError:/d' \
    -e '/libjansi\.so: dlopen failed: library "libc\.so\.6" not found/d' \
    -e '/^info: kotlinc-jvm /d' \
    "$1"
}

filter_d8_output() {
  if [ ! -f "$1" ]; then
    return 0
  fi

  sed \
    -e "/^Info: Unexpected error while reading .*'s kotlin\\.Metadata:/d" \
    "$1"
}

if [ -n "$KOTLIN_SOURCES" ]; then
  if ! env TERM=dumb JAVACMD="$JAVA_HOME/bin/java" kotlinc \
      $KOTLIN_SOURCES \
      $JAVA_SOURCES \
      -jvm-target 1.8 \
      -classpath "$COMPILE_CLASSPATH" \
      -d "$CLASSES_DIR" \
      2>"$BUILD_DIR/kotlinc.stderr"; then
    cat "$BUILD_DIR/kotlinc.stderr"
    exit 1
  fi

  filter_kotlinc_stderr "$BUILD_DIR/kotlinc.stderr" > "$BUILD_DIR/kotlinc.filtered.stderr"
  if [ -s "$BUILD_DIR/kotlinc.filtered.stderr" ]; then
    cat "$BUILD_DIR/kotlinc.filtered.stderr"
  fi
fi

if [ -n "$JAVA_SOURCES" ]; then
  javac \
    -encoding UTF-8 \
    -source 8 \
    -target 8 \
    -bootclasspath "$ANDROID_JAR" \
    -classpath "$COMPILE_CLASSPATH:$CLASSES_DIR" \
    -d "$CLASSES_DIR" \
    $JAVA_SOURCES
fi

jar cf "$BUILD_DIR/classes.jar" -C "$CLASSES_DIR" .

if [ -n "$KOTLIN_SOURCES" ]; then
  if ! d8 \
      --lib "$ANDROID_JAR" \
      --output "$DEX_DIR" \
      "$BUILD_DIR/classes.jar" \
      "$KOTLIN_STD_JAR" \
      "$KOTLIN_STD_JDK7_JAR" \
      "$KOTLIN_STD_JDK8_JAR" \
      >"$BUILD_DIR/d8.stdout" \
      2>"$BUILD_DIR/d8.stderr"; then
    cat "$BUILD_DIR/d8.stdout"
    cat "$BUILD_DIR/d8.stderr"
    exit 1
  fi

  filter_d8_output "$BUILD_DIR/d8.stdout" > "$BUILD_DIR/d8.filtered.stdout"
  if [ -s "$BUILD_DIR/d8.filtered.stdout" ]; then
    cat "$BUILD_DIR/d8.filtered.stdout"
  fi

  if [ -s "$BUILD_DIR/d8.stderr" ]; then
    cat "$BUILD_DIR/d8.stderr"
  fi
else
  d8 \
    --lib "$ANDROID_JAR" \
    --output "$DEX_DIR" \
    "$BUILD_DIR/classes.jar"
fi

cp "$DEX_DIR/classes.dex" "$BUILD_DIR/classes.dex"
aapt add -k "$UNSIGNED_APK" "$BUILD_DIR/classes.dex"

if [ ! -f "$KEYSTORE" ]; then
  keytool -genkeypair \
    -keystore "$KEYSTORE" \
    -storepass android \
    -keypass android \
    -alias androiddebugkey \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -dname "CN=Android Debug,O=Android,C=US" \
    -noprompt
fi

apksigner sign \
  --ks "$KEYSTORE" \
  --ks-key-alias androiddebugkey \
  --ks-pass pass:android \
  --key-pass pass:android \
  --out "$SIGNED_APK" \
  "$UNSIGNED_APK"

apksigner verify "$SIGNED_APK"
echo "Built: $SIGNED_APK"
