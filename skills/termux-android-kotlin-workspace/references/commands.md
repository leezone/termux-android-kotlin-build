# Commands

## Environment

```sh
. ./env-android.sh
```

## Setup

```sh
sh ./scripts/setup-android-sdk.sh
sh ./scripts/setup-re-tools.sh
sh ./scripts/install-local-skill.sh
```

## Portable skill bootstrap

```sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/install-toolchain.sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/install-re-tools.sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/init-project.sh /path/to/my-app com.example.myapp "My App"
```

One-shot bootstrap:

```sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/bootstrap-project.sh /path/to/my-app com.example.myapp "My App"
```

## Build and run

```sh
sh ./build.sh
sh ./install.sh
sh ./launch.sh
```

## Reverse engineering

```sh
sh ./decompile.sh build/app-debug.apk
sh ./apktool.sh d build/app-debug.apk -o out/apktool
```

## Git push with proxy

```sh
export http_proxy=http://127.0.0.1:2080
export https_proxy=http://127.0.0.1:2080
git push
```
