<#
  build_windows_installer.ps1
  One-shot: build the Flutter Windows Release and package it into
  dist\Setup.exe with Inno Setup. Run on a Windows machine from any directory.

  Prerequisites (Windows only):
    - Flutter SDK (Dart >= 3.13), with `flutter config --enable-windows-desktop`
    - Visual Studio 2022 with the "Desktop development with C++" workload
    - Inno Setup 6  (https://jrsoftware.org/isdl.php)

  Usage:
    powershell -ExecutionPolicy Bypass -File scripts\build_windows_installer.ps1
#>

$ErrorActionPreference = 'Stop'

# Project root = parent of this script's folder.
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
Write-Host "==> Project: $root"

Write-Host "==> flutter pub get"
flutter pub get

Write-Host "==> build_runner codegen (freezed / json_serializable / riverpod / drift)"
dart run build_runner build --delete-conflicting-outputs

Write-Host "==> flutter build windows --release"
flutter build windows --release

$releaseDir = Join-Path $root 'build\windows\x64\runner\Release'
if (-not (Test-Path (Join-Path $releaseDir 'saydaliati.exe'))) {
    throw "Release build not found at $releaseDir — did `flutter build windows` succeed?"
}

# Locate ISCC.exe (Inno Setup compiler) — machine-wide or per-user install.
$iscc = $null
foreach ($p in @(
        "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
        "$env:ProgramFiles\Inno Setup 6\ISCC.exe",
        "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe")) {
    if ($p -and (Test-Path $p)) { $iscc = $p; break }
}
if (-not $iscc) {
    $cmd = Get-Command ISCC.exe -ErrorAction SilentlyContinue
    if ($cmd) { $iscc = $cmd.Source }
}
if (-not $iscc) {
    throw "ISCC.exe (Inno Setup 6) not found. Install it from https://jrsoftware.org/isdl.php"
}
Write-Host "==> Inno Setup: $iscc"

& $iscc "windows\installer\saydaliati.iss"
if ($LASTEXITCODE -ne 0) { throw "Inno Setup failed with exit code $LASTEXITCODE" }

$setup = Join-Path $root 'dist\Setup.exe'
Write-Host ""
Write-Host "==> Done. Installer at: $setup"
Get-Item $setup | Format-List Name, Length, LastWriteTime
