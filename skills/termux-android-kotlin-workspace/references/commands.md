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
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/init-project.sh /path/to/my-app com.example.myapp "My App" 34 34 26
```

One-shot bootstrap:

```sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/bootstrap-project.sh /path/to/my-app com.example.myapp "My App" 34 34 26
```

Android 9 / API 28 example:

```sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/install-toolchain.sh 28 34
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/init-project.sh /path/to/my-app com.example.myapp "My App" 28 28 28
```

`sdkmanager` proxy example:

```sh
export SDKMANAGER_PROXY_TYPE=http
export SDKMANAGER_PROXY_HOST=127.0.0.1
export SDKMANAGER_PROXY_PORT=2080
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/install-toolchain.sh 34
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
