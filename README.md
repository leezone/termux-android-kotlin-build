# Termux 安卓 Kotlin 本地编译与反编译环境

这个仓库提供一套在 Android 手机上的 Termux 环境中直接使用的 APK 工作流，包含：

- Kotlin Android 应用本地编译
- APK 打包与调试签名
- 当前手机直接安装与启动
- `jadx` + `apktool` 反编译与资源解包

## 功能概览

- 在 Termux 中本地生成 Android APK
- 使用自动生成的 `debug.keystore` 完成签名
- 支持直接打开系统安装器安装 APK
- 支持将 APK 反编译成 Java 源码、smali 与资源文件

## 目录结构

- `src/com/example/termuxlocalapp/MainActivity.kt`：示例 Kotlin Activity
- `build.sh`：编译、dex、打包、签名
- `install.sh`：调用系统安装器安装 APK
- `launch.sh`：启动已安装应用
- `decompile.sh`：执行 `jadx`、`aapt` 元数据导出、可选 `apktool` 解包
- `apktool.sh`：直接调用本地 `apktool.jar`
- `env-android.sh`：导出 `JAVA_HOME`、`ANDROID_HOME`、Kotlin 路径
- `scripts/setup-android-sdk.sh`：安装 Android SDK 平台文件
- `scripts/setup-re-tools.sh`：安装 `jadx` 并下载 `apktool`
- `scripts/install-local-skill.sh`：把仓库内 skill 安装到本地 Codex skills 目录
- `skills/termux-android-kotlin-workspace/SKILL.md`：仓库内置 skill
- `CHANGELOG.md`：仓库变更记录

## 首次环境准备

这里分成两个场景。

### 场景 A：直接使用当前仓库

如果你就是在当前仓库里继续维护和测试，进入仓库目录后执行：

```sh
cd <repo-dir>
sh scripts/setup-android-sdk.sh
sh scripts/setup-re-tools.sh
sh scripts/install-local-skill.sh
```

当前仓库默认兼容的环境：

- Android SDK：`/data/data/com.termux/files/usr/tmp/termux-android-sdk`
- JDK：17
- Target API：34

### 场景 B：正式项目用 skill 初始化

如果你后续要做正式项目，建议直接用 skill 起一个新目录，而不是继续在这个演示仓库里写：

```sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/bootstrap-project.sh /path/to/my-app com.example.myapp "My App"
```

skill 初始化出的新项目默认使用共享工具目录：

- Android SDK：`~/.local/share/termux-android-kotlin/sdk`
- apktool：`~/.local/share/termux-android-kotlin/apktool.jar`

如果 `sdkmanager` 拉不到某个旧平台，可以把已有 SDK 或平台目录写进：

```sh
export ANDROID_PLATFORM_SRC=/path/to/sdk-or-platform:/another/path
```

脚手架会尝试把其中的 `android-28`、`android-34` 之类平台复制到共享 SDK 目录里。

如果你确实要给 `sdkmanager` 传代理参数，可以这样：

```sh
export SDKMANAGER_PROXY_TYPE=http
export SDKMANAGER_PROXY_HOST=127.0.0.1
export SDKMANAGER_PROXY_PORT=2080
```

然后再执行：

```sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/install-toolchain.sh 28 34
```

注意：

- `--proxy_host` 应该填代理服务器，例如 `127.0.0.1`
- `mirrors.tuna.tsinghua.edu.cn` 是镜像站，不是 HTTP 代理
- 在 Termux `aarch64` 下，优先安装 `platforms;android-XX`，不要依赖 Google 官方 `platform-tools` / `build-tools` 的 Linux 二进制

目前实测结论：

- skill 的初始化、编译、反编译逻辑本身是正常的
- 真正最容易失败的是 `sdkmanager` 下载平台包这一步
- 在 Neko 场景下，显式使用 `HTTP` 代理参数访问 `dl.google.com` 比直接猜测 `SOCKS5` 更稳
- 如果 `platforms;android-28` 这类旧平台第一次没拉下来，重新切节点或重试一次后可能恢复正常

## 编译、安装、启动

```sh
cd <repo-dir>
. ./env-android.sh
sh ./gradlew lint
sh ./gradlew assembleDebug
sh ./gradlew installDebug
sh ./gradlew launchDebug
```

如果你更想直接走原始 Termux 脚本，也可以继续：

```sh
sh build.sh
sh install.sh
sh launch.sh
```

产物位置：

- 已签名 APK：`build/app-debug.apk`
- 未签名 APK：`build/app-unsigned.apk`
- 调试签名：`debug.keystore`

补充说明：

- 当前仓库位于 Android 共享存储 `/storage/emulated/0/...`
- 这类目录通常不能直接执行脚本，所以 `./gradlew` 可能报 `Permission denied`
- 在这里请使用 `sh ./gradlew ...`

## 反编译用法

反编译当前仓库生成的 APK：

```sh
sh ./gradlew decompileDebug
```

输出目录：

- `decompiled/<apk-name>/jadx/`：Java 源码与提取后的资源
- `decompiled/<apk-name>/apktool/`：smali、清单、资源解包结果
- `decompiled/<apk-name>/meta/`：`aapt` 和归档元数据输出

直接运行 `apktool`：

```sh
sh apktool.sh d build/app-debug.apk -o out/apktool
```

## Skill

这个仓库自带一个 repo 级 skill：

- `skills/termux-android-kotlin-workspace/`

安装到本地 Codex skills 目录：

```sh
sh scripts/install-local-skill.sh
```

安装后，后续在这个仓库中做构建、安装、反编译、修复脚本时，可以优先复用现有流程，而不是重新搭建工具链。

## 用 Skill 初始化正式项目

现在这个 skill 已经不只是当前仓库的说明书，也可以直接在任意目录里生成一个新的 Termux Android Kotlin 项目。

推荐流程：

```sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/install-toolchain.sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/install-re-tools.sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/init-project.sh /path/to/my-app com.example.myapp "My App"
```

或者一步完成：

```sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/bootstrap-project.sh /path/to/my-app com.example.myapp "My App"
```

Android 9 / API 28 示例：

```sh
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/install-toolchain.sh 28 34
sh ~/.codex/skills/termux-android-kotlin-workspace/scripts/init-project.sh /path/to/my-app com.example.myapp "My App" 28 28 28
```

初始化后的新项目会自带：

- `gradlew`
- `gradle/wrapper/`
- `build.gradle`
- `settings.gradle`
- `gradle.properties`
- `build.sh`
- `install.sh`
- `launch.sh`
- `decompile.sh`
- `apktool.sh`
- `env-android.sh`
- `scripts/setup-android-sdk.sh`
- `scripts/setup-re-tools.sh`
- Kotlin `MainActivity.kt` 模板

也就是说，后续正式编码时，你可以直接复用这套 skill 的脚手架，而不是从头再搭环境。

## Git 与推送

当前仓库已经初始化为 Git 仓库。常用命令：

```sh
git add .
git commit -m "更新说明或脚本"
export http_proxy=http://127.0.0.1:2080
export https_proxy=http://127.0.0.1:2080
git push
```

当前远端仓库：

`https://github.com/leezone/termux-android-kotlin-build`

## 网络与代理

如果访问 GitHub 或下载上游依赖较慢，先设置本地代理：

```sh
export http_proxy=http://127.0.0.1:2080
export https_proxy=http://127.0.0.1:2080
```

## 已知限制

- 这套流程面向真实 Android 设备，不包含模拟器支持。
- `jadx` 在部分 APK 上可能报告“部分反编译错误”，但通常仍会导出可用源码。
- 当前 Termux 下的 `d8` 对新版 Kotlin metadata 可能输出信息级提示，但只要命令退出成功，APK 仍可正常生成。
- 下载 Android 平台包时，最脆弱的环节是 `sdkmanager -> dl.google.com/android/repository`。一旦网络抖动，可优先尝试：
  - 重试
  - 更换 Neko 节点
  - 显式设置 `SDKMANAGER_PROXY_TYPE=http`
  - 使用 `ANDROID_PLATFORM_SRC` 做离线导入

## English Summary

This repository provides a Termux-based Android workflow for Kotlin APK build, install, launch, and reverse engineering on a real Android device. Use `sh ./gradlew lint`, `sh ./gradlew assembleDebug`, and `sh ./gradlew decompileDebug` as the main entry points, with the shell scripts kept as the underlying compatible pipeline.
