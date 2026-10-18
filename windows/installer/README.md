# Windows installer (Setup.exe)

Packages the Saydaliati Flutter **Windows Release** build into a single
installable `dist/Setup.exe` using **Inno Setup 6**. No app logic or features
are changed — this only packages the already-built Release output.

## Why this must run on Windows
`flutter build windows` compiles native C++ with the MSVC / Visual Studio
toolchain and **only runs on a Windows host** (there is no Linux→Windows
cross-compile for Flutter desktop). Inno Setup's compiler (`ISCC.exe`) is also
a Windows tool. So the actual `Setup.exe` has to be produced on a Windows
machine.

## Prerequisites (Windows)
- Flutter SDK (Dart ≥ 3.13) — `flutter config --enable-windows-desktop`
- Visual Studio 2022 with **Desktop development with C++**
- Inno Setup 6 — https://jrsoftware.org/isdl.php

## Build (one command)
From the project root:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\build_windows_installer.ps1
```

This runs `flutter pub get` → `build_runner` codegen →
`flutter build windows --release` → Inno Setup, and writes **`dist\Setup.exe`**.

### Manual steps (equivalent)
```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build windows --release
"%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" windows\installer\saydaliati.iss
```

## What the installer does
- Installs into **Program Files** (`{autopf}\Saydaliati`) — needs admin elevation.
- Bundles the whole Release folder: `saydaliati.exe`, `flutter_windows.dll`,
  every plugin DLL, and `data\` (flutter_assets + `icudtl.dat`).
- Creates a **desktop shortcut by default** (the task is pre-checked; the user
  need not tick anything) and a **Start-menu** shortcut.
- Registers a proper **uninstaller** in Windows "Apps & features" / Add-Remove
  Programs (stable `AppId`, so updates reuse the same entry).
- **Preserves local user data** on update / reinstall / uninstall: the app's
  data (Drift DB, secure storage, preferences) lives under
  `%APPDATA%\com.saydaliati\`, outside the install dir, and is never touched.

## Visual C++ runtime — the `VCRUNTIME140_1.dll was not found` error

### Why it happens
`flutter build windows` compiles the runner with MSVC, and the produced
`saydaliati.exe` links **dynamically** against the Microsoft C++ runtime.
Verified by reading the EXE's import table:

```
MSVCP140.dll        VCRUNTIME140.dll        VCRUNTIME140_1.dll
api-ms-win-crt-*.dll   (Universal CRT — part of Windows 10/11, always present)
```

The three `*140*.dll` files are **not** part of Windows. A development machine
has them because Visual Studio installs them; a clean customer machine does
not, so the app dies at startup with

> The code execution cannot proceed because **VCRUNTIME140_1.dll** was not found.

before it paints anything. It is a packaging gap, never an app bug — which is
why nothing in `lib/` changes to fix it.

### How it is solved here
`Setup.exe` carries **Microsoft's own redistributable installer**
(`vc_redist.x64.exe`) and runs it silently when the machine needs it:

1. `scriptsuild_windows_installer.ps1` stages the redist into
   `buildedistc_redist.x64.exe` — copied from the local Visual Studio
   installation when present (first-party, no network), otherwise downloaded
   from Microsoft's official permalink `https://aka.ms/vs/17/release/vc_redist.x64.exe`.
2. Either way its **Authenticode signature is verified** (valid, signer
   `O=Microsoft Corporation`) before it is packaged. A runtime installer runs
   elevated on every customer machine; an unverified binary is not acceptable.
   Individual DLLs are never downloaded from third-party "DLL sites".
3. `saydaliati.iss` embeds it with `Flags: dontcopy` and, in
   `PrepareToInstall`, checks whether the runtime is already present:
   - registry `HKLM\SOFTWARE\Microsoft\VisualStudio.0\VC\Runtimes\X64`
     → `Installed = 1` and `Bld >= 29325`, read in **both** registry views
     (the redist installer is 32-bit, so the key can live under WOW6432Node);
   - **plus** a real check that `%SystemRoot%\System32\VCRUNTIME140_1.dll`
     exists — a stale registry key left by a partial uninstall would otherwise
     make Setup skip the step and hand over an app that cannot start.
4. If needed it runs `vc_redist.x64.exe /install /passive /norestart` and maps
   the exit code: `0` = done, `1638` = a newer version is already installed,
   `3010` = installed, restart required (Setup asks for the restart), anything
   else aborts the install with a clear Arabic message instead of leaving a
   broken app behind.

Installing the redistributable **centrally** (rather than copying DLLs into
`System32` by hand) is the supported path: the files stay serviced by Windows
Update, and other apps on the machine are not disturbed.

### Portable package (no admin rights)
Some machines cannot run an elevated installer. For those:

```powershell
powershell -ExecutionPolicy Bypass -File scriptsuild_windows_installer.ps1 -Portable
```

This additionally writes `dist\Saydaliati-<version>-portable.zip`: the complete
Release folder **plus app-local copies** of exactly the three DLLs the exe
imports (`vcruntime140.dll`, `vcruntime140_1.dll`, `msvcp140.dll`, each
signature-verified, taken from the Visual Studio redist folder). Windows
searches the executable's own directory first, so the app runs with no
machine-wide runtime and no admin rights. Verified by launching the unzipped
build and listing its loaded modules — all three resolve to the app folder.

Trade-off worth knowing: app-local copies are **not serviced by Windows
Update**, so a security fix to the C++ runtime reaches installer users but not
zip users. `Setup.exe` stays the recommended channel; the zip is the fallback.

### Never ship the EXE alone
`saydaliati.exe` is useless on its own: it needs `flutter_windows.dll`, every
plugin DLL, and the whole `data\` folder (`flutter_assets`, `icudtl.dat`)
beside it. Both outputs above carry the complete tree — `Setup.exe` through
`Flags: recursesubdirs createallsubdirs`, and the zip by copying the Release
folder wholesale. Copying just the EXE out of `build\` produces exactly the
same class of "DLL not found" failures.

### Offline operation is unaffected
None of this touches application logic. The local-first behaviour — the Drift
cache, the outbox queue, and sync-on-reconnect — is unchanged, and the data
still lives in `%APPDATA%\com.saydaliati\`, outside the install directory.

## Customize
- Version: bump `MyAppVersion` in `saydaliati.iss` (keep it in sync with
  `pubspec.yaml`).
- Never change `AppId` — it is the identity used for upgrades/uninstall.
