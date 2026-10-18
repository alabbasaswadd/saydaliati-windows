<#
  build_windows_installer.ps1
  One-shot: build the Flutter Windows Release and package it into
  dist\Setup.exe with Inno Setup. Run on a Windows machine from any directory.

  Prerequisites (Windows only):
    - Flutter SDK (Dart >= 3.13), with `flutter config --enable-windows-desktop`
    - Visual Studio 2022+ with the "Desktop development with C++" workload
    - Inno Setup 6  (https://jrsoftware.org/isdl.php)

  Usage:
    powershell -ExecutionPolicy Bypass -File scripts\build_windows_installer.ps1
    powershell -ExecutionPolicy Bypass -File scripts\build_windows_installer.ps1 -Portable

  -Portable also produces dist\Saydaliati-<version>-portable.zip: the Release
  folder with the three C++ runtime DLLs copied in beside the exe, for machines
  where an admin installer cannot be run.
#>

param(
    [switch]$Portable
)

$ErrorActionPreference = 'Stop'

# Project root = parent of this script's folder.
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
Write-Host "==> Project: $root"

# ---------------------------------------------------------------------------
#  Visual C++ runtime
#
#  A Flutter Windows app is built with MSVC and links dynamically against
#  VCRUNTIME140.dll, VCRUNTIME140_1.dll and MSVCP140.dll. Windows does NOT ship
#  them: on a clean machine the app dies at startup with
#  "VCRUNTIME140_1.dll was not found" before painting anything.
#
#  So the installer carries Microsoft's own redistributable installer. It is
#  taken from the local Visual Studio installation when present (first-party,
#  no network), and otherwise downloaded from Microsoft's official permalink.
#  Either way its Authenticode signature is verified before use — a runtime
#  installer runs elevated on every customer machine, so an unverified binary
#  is not an option.
# ---------------------------------------------------------------------------
$redistDir = Join-Path $root 'build\redist'
$redistExe = Join-Path $redistDir 'vc_redist.x64.exe'
$redistUrl = 'https://aka.ms/vs/17/release/vc_redist.x64.exe'

# Visual Studio install roots - used for both the redist installer and, with
# -Portable, the app-local runtime DLLs. Defined once at top level so the
# portable step does not depend on which branch staged the redist.
$vsRoots = @(
    "$env:ProgramFiles\Microsoft Visual Studio",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio"
) | Where-Object { Test-Path $_ }

function Assert-MicrosoftSigned([string]$path) {
    $sig = Get-AuthenticodeSignature -FilePath $path
    if ($sig.Status -ne 'Valid') {
        throw "Signature check failed for $path (status: $($sig.Status))."
    }
    if ($sig.SignerCertificate.Subject -notmatch 'O=Microsoft Corporation') {
        throw "Unexpected signer for $path : $($sig.SignerCertificate.Subject)"
    }
    Write-Host "    signature: Valid, Microsoft Corporation"
}

Write-Host "==> Visual C++ redistributable"
if (-not (Test-Path $redistDir)) { New-Item -ItemType Directory -Force $redistDir | Out-Null }

if (Test-Path $redistExe) {
    Write-Host "    already staged: $redistExe"
    Assert-MicrosoftSigned $redistExe
}
else {
    # Newest vc_redist.x64.exe shipped with any local Visual Studio install.
    $local = $null
    foreach ($vs in $vsRoots) {
        $found = Get-ChildItem -Path $vs -Recurse -Filter 'vc_redist.x64.exe' -ErrorAction SilentlyContinue |
                 Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($found) { $local = $found; break }
    }

    if ($local) {
        Write-Host "    copying from Visual Studio: $($local.FullName)"
        Copy-Item $local.FullName $redistExe -Force
    }
    else {
        Write-Host "    not found locally - downloading from $redistUrl"
        Invoke-WebRequest -Uri $redistUrl -OutFile $redistExe -UseBasicParsing
    }
    Assert-MicrosoftSigned $redistExe
}

Write-Host "==> flutter pub get"
flutter pub get

Write-Host "==> build_runner codegen (freezed / json_serializable / riverpod / drift)"
dart run build_runner build --delete-conflicting-outputs

Write-Host "==> flutter build windows --release"
flutter build windows --release

$releaseDir = Join-Path $root 'build\windows\x64\runner\Release'
if (-not (Test-Path (Join-Path $releaseDir 'saydaliati.exe'))) {
    throw "Release build not found at $releaseDir - did `flutter build windows` succeed?"
}

# Locate ISCC.exe (Inno Setup compiler) - machine-wide or per-user install.
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

# ---------------------------------------------------------------------------
#  Portable package (optional)
#
#  Same Release folder plus app-local copies of the three runtime DLLs the exe
#  imports. Windows searches the executable's own directory first, so the app
#  runs without the machine-wide redistributable and without admin rights.
#
#  App-local deployment is supported by Microsoft, with one trade-off worth
#  knowing: these copies are NOT serviced by Windows Update, so a security fix
#  to the C++ runtime reaches the installer flow but not this zip. The
#  installer remains the recommended channel.
# ---------------------------------------------------------------------------
if ($Portable) {
    Write-Host ""
    Write-Host "==> Portable package"

    $crtDir = Get-ChildItem -Path $vsRoots -Recurse -Directory -Filter 'Microsoft.VC*.CRT' -ErrorAction SilentlyContinue |
              Where-Object { $_.FullName -match '\\x64\\' -and $_.FullName -notmatch 'onecore|debug' } |
              Sort-Object FullName -Descending | Select-Object -First 1
    if (-not $crtDir) {
        throw "Visual C++ redist DLL folder (Microsoft.VC14x.CRT\x64) not found - install the VS C++ workload."
    }
    Write-Host "    runtime DLLs from: $($crtDir.FullName)"

    # Exactly what the exe imports (msvcp140 itself pulls only the two vcruntime
    # DLLs), so nothing unnecessary ships.
    $needed = @('vcruntime140.dll', 'vcruntime140_1.dll', 'msvcp140.dll')

    $stage = Join-Path $root 'build\portable\Saydaliati'
    if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
    New-Item -ItemType Directory -Force $stage | Out-Null
    Copy-Item (Join-Path $releaseDir '*') $stage -Recurse -Force

    foreach ($dll in $needed) {
        $src = Join-Path $crtDir.FullName $dll
        if (-not (Test-Path $src)) { throw "Missing $dll in $($crtDir.FullName)" }
        Assert-MicrosoftSigned $src
        Copy-Item $src $stage -Force
    }

    $version = (Select-String -Path (Join-Path $root 'pubspec.yaml') -Pattern '^version:\s*(.+)$').Matches[0].Groups[1].Value.Trim()
    $zip = Join-Path $root "dist\Saydaliati-$version-portable.zip"
    if (Test-Path $zip) { Remove-Item $zip -Force }
    Compress-Archive -Path $stage -DestinationPath $zip -CompressionLevel Optimal

    Write-Host "==> Portable zip: $zip"
    Get-Item $zip | Format-List Name, Length, LastWriteTime
}
