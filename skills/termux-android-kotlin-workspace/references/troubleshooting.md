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

## Git says `dubious ownership`

Mark the repository as safe:

```sh
git config --global --add safe.directory /storage/emulated/0/termux/project/1
```
