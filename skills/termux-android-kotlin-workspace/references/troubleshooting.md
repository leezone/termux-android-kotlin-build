# Troubleshooting

## GitHub download is slow

Set the local proxy before running `curl`, `git push`, or setup scripts:

```sh
export http_proxy=http://127.0.0.1:2080
export https_proxy=http://127.0.0.1:2080
```

## `d8` prints Kotlin metadata info lines

Treat these as noise when `build.sh` exits successfully and `build/app-debug.apk` is generated.

## `jadx` exits with partial errors

If `decompiled/<apk-name>/jadx/sources/` exists, keep going. The exported Java is usually still usable.

## `aapt dump xmltree` fails

The decompile script treats this as non-fatal and preserves the rest of the metadata and decode outputs.

## `sdkmanager` cannot fetch manifests

The bundled setup scripts try `sdkmanager` first. If that fails and an existing local SDK already contains `platforms/android-34`, they fall back to copying that platform into the shared SDK root.

If you have a local SDK or an extracted platform directory, point `ANDROID_PLATFORM_SRC` at it. The scripts will try those paths before giving up.

If you need to pass proxy flags to `sdkmanager`, use:

```sh
export SDKMANAGER_PROXY_TYPE=http
export SDKMANAGER_PROXY_HOST=127.0.0.1
export SDKMANAGER_PROXY_PORT=2080
```

Do not use a mirror hostname such as `mirrors.tuna.tsinghua.edu.cn` as `proxy_host`. That host is a mirror, not a forward proxy.

## Git says `dubious ownership`

Mark the repository as safe:

```sh
git config --global --add safe.directory "$(pwd)"
```
