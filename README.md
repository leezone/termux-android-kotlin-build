# Termux Android Kotlin Build

This repository provides a local Android APK build and reverse-engineering workflow for Termux on Android. It uses Kotlin for app code and Termux-native tools for packaging, signing, and decompilation.

## What this repo does

- Builds a Kotlin Android APK locally in Termux
- Signs the APK with a generated debug keystore
- Installs and launches the app on the current phone
- Decompiles APKs with `jadx` and `apktool`

## Project layout

- `src/com/example/termuxlocalapp/MainActivity.kt`: sample Kotlin activity
- `build.sh`: compile, dex, package, and sign the APK
- `install.sh`: open the Android package installer
- `launch.sh`: launch the installed app
- `decompile.sh`: run `jadx`, metadata dumps, and optional `apktool`
- `scripts/setup-android-sdk.sh`: install Android platform files into Termux storage
- `scripts/setup-re-tools.sh`: install `jadx` and download `apktool`
- `env-android.sh`: export `JAVA_HOME`, `ANDROID_HOME`, and Kotlin paths

## First-time setup

Run these once in a fresh Termux environment:

```sh
cd /storage/emulated/0/termux/project/1
sh scripts/setup-android-sdk.sh
sh scripts/setup-re-tools.sh
```

The Android SDK is stored at `/data/data/com.termux/files/usr/tmp/termux-android-sdk`. The project currently targets API 34 and uses JDK 17.

## Build, install, launch

```sh
cd /storage/emulated/0/termux/project/1
. ./env-android.sh
sh build.sh
sh install.sh
sh launch.sh
```

Build output:

- Signed APK: `build/app-debug.apk`
- Unsigned APK: `build/app-unsigned.apk`
- Debug keystore: `debug.keystore`

## Reverse engineering

Decompile the APK produced by this repo:

```sh
sh decompile.sh build/app-debug.apk
```

Outputs:

- `decompiled/<apk-name>/jadx/`: Java sources and extracted resources
- `decompiled/<apk-name>/apktool/`: smali and decoded resources when `apktool.jar` is present
- `decompiled/<apk-name>/meta/`: `aapt` and archive metadata dumps

Run `apktool` directly:

```sh
sh apktool.sh d build/app-debug.apk -o out/apktool
```

## Networking note

If GitHub or other upstream downloads are unstable in Termux, use the local proxy:

```sh
export http_proxy=http://127.0.0.1:2080
export https_proxy=http://127.0.0.1:2080
```

## Known constraints

- This workflow is designed for a real Android device, not an emulator.
- The current `d8` build can emit Kotlin metadata info lines; the APK still builds and verifies successfully.
- `jadx` may report partial decompilation errors on some APKs while still exporting usable sources.

## Git workflow

This directory was prepared to be versioned in Git. Recommended commands:

```sh
git init
git add .
git commit -m "Add Termux Android Kotlin build workflow"
```
