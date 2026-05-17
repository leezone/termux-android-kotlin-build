# Reverse Engineering Notes

## Output layout

- `decompiled/<apk-name>/jadx/`: high-level Java source view
- `decompiled/<apk-name>/apktool/`: smali, decoded manifest, resources
- `decompiled/<apk-name>/meta/`: `aapt` output and archive listings

## Which tool to use

- Use `jadx` first when reading logic quickly.
- Use `apktool` when inspecting resources, manifest rewrites, smali, or file layout.
- Use both when comparing high-level flow against low-level implementation.

## Recommended flow

1. Run `sh ./decompile.sh build/app-debug.apk`
2. Open `jadx/sources/` for code reading
3. Open `apktool/AndroidManifest.xml` and `apktool/smali/` for low-level details
4. Check `meta/badging.txt` for package and activity details
