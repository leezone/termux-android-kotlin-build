# Changelog

## 2026-05-17

- 初始化 Termux 本地 Android Kotlin 编译环境
- 增加 `build.sh`、`install.sh`、`launch.sh`
- 增加 `decompile.sh`、`apktool.sh`
- 增加 SDK 与逆向工具安装脚本
- 增加仓库内 skill：`termux-android-kotlin-workspace`
- README 改为中文优先，并保留英文摘要
- skill 升级为可移植脚手架，支持在新目录初始化 Kotlin Android 项目
- 补充 Neko / sdkmanager 代理排障结论与网络抖动说明

## 2026-06-06

- 为仓库增加 `gradlew`、`gradle/wrapper/` 和最小 Gradle 配置
- 增加 `lint`、`check`、`assembleDebug`、`installDebug`、`launchDebug`、`decompileDebug` 任务
- 保持 `build.sh` / `install.sh` / `launch.sh` / `decompile.sh` 作为底层兼容实现
- 更新 skill 模板与初始化脚本，使新项目默认自带 Gradle Wrapper
