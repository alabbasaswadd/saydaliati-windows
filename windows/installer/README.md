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

## Customize
- Version: bump `MyAppVersion` in `saydaliati.iss` (keep it in sync with
  `pubspec.yaml`).
- Never change `AppId` — it is the identity used for upgrades/uninstall.
