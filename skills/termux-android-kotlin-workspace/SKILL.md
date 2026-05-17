---
name: termux-android-kotlin-workspace
description: Use when working in this repository to build, install, launch, or decompile Android APKs from Termux using the provided Kotlin-based scripts and local SDK setup.
---

# Termux Android Kotlin Workspace

This skill is repo-specific. Use it when the current workspace is this repository or a clone of it.

## Quick start

1. Source the environment:
   `. ./env-android.sh`
2. Build the app:
   `sh ./build.sh`
3. Install and launch:
   `sh ./install.sh`
   `sh ./launch.sh`
4. Decompile an APK:
   `sh ./decompile.sh build/app-debug.apk`

## Preferred workflow

- Reuse the existing scripts instead of rebuilding the Android toolchain manually.
- Use `sh ./scripts/setup-android-sdk.sh` for SDK provisioning.
- Use `sh ./scripts/setup-re-tools.sh` for `jadx` and `apktool`.
- Edit app code under `src/`.
- Treat `build/`, `decompiled/`, and `tools/` as generated outputs unless the task is explicitly about those artifacts.

## Paths that matter

- `./build.sh`
- `./decompile.sh`
- `./apktool.sh`
- `./env-android.sh`
- `./scripts/setup-android-sdk.sh`
- `./scripts/setup-re-tools.sh`
- `./src/com/example/termuxlocalapp/MainActivity.kt`

## Troubleshooting

- If GitHub downloads are unstable, use `127.0.0.1:2080` as an HTTP/HTTPS proxy.
- If `build.sh` prints Kotlin metadata info lines from `d8`, treat them as noise unless the command exits nonzero.
- If `jadx` exits with partial errors but exports sources, continue and inspect the generated output under `decompiled/`.
