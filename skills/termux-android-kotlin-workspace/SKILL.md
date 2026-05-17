---
name: termux-android-kotlin-workspace
description: Use when working in this repository to build, install, launch, push, or decompile Android APKs from Termux using the provided Kotlin-based scripts, local SDK setup, and reverse-engineering workflow.
---

# Termux Android Kotlin Workspace

This skill is repo-specific. Use it when the current workspace is this repository or a clone of it.

## Trigger examples

- “在这个仓库里编译 APK”
- “帮我安装并启动这个安卓应用”
- “把这个 APK 反编译出来看看”
- “更新 Termux 下的 Android SDK / 逆向工具”
- “在这个仓库继续维护 build 脚本或 README”
- “帮我在新目录初始化一个 Termux Android Kotlin 项目”
- “把这套安卓环境作为 skill 应用到正式项目里”

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
- For new projects outside this repository, use the skill scripts under `scripts/` plus the bundled template under `assets/project-template/`.

## Portable bootstrap

This skill is no longer only a repo guide. It also contains a reusable Termux Android Kotlin project template.

Use these scripts from the installed skill directory:

1. `scripts/install-toolchain.sh`
2. `scripts/install-re-tools.sh`
3. `scripts/init-project.sh <target-dir> [package] [app-label]`

Or one-shot:

1. `scripts/bootstrap-project.sh <target-dir> [package] [app-label]`

## Read these references when needed

- For copy-ready commands: `references/commands.md`
- For reverse engineering workflow: `references/reverse-engineering.md`
- For common failures and fixes: `references/troubleshooting.md`

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
- If a task needs exact commands or deeper troubleshooting, read the matching file in `references/`.
