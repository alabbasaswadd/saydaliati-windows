; ============================================================================
;  Saydaliati (صيدليتي) — Windows installer script for Inno Setup 6
;  Produces a single, self-contained "Setup.exe" that installs the Flutter
;  Windows release build into Program Files, with desktop + Start-menu
;  shortcuts and a Windows "Add/Remove Programs" uninstaller.
;
;  Build the app FIRST (produces build\windows\x64\runner\Release), then
;  compile this script. The helper scripts\build_windows_installer.ps1 does
;  both in one step.
;
;  It does NOT change any app logic — it only packages the already-built
;  Release output.
; ============================================================================

#define MyAppName "صيدليتي"
#define MyAppNameLatin "Saydaliati"
#define MyAppVersion "1.2.0"
#define MyAppPublisher "CodeTech Syria"
#define MyAppExeName "saydaliati.exe"
; Release output of `flutter build windows --release`, relative to this file
; (windows\installer\  ->  project root is two levels up).
#define BuildDir "..\..\build\windows\x64\runner\Release"

[Setup]
; A STABLE AppId — keep it unchanged forever so updates/reinstalls map to the
; same Add/Remove-Programs entry (and user data is preserved across upgrades).
AppId={{A3F1C9E2-5D47-4B8A-9E6C-1F2B3C4D5E6F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
VersionInfoVersion={#MyAppVersion}
; Default install location: Program Files (requires admin elevation below).
DefaultDirName={autopf}\{#MyAppNameLatin}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
; One installer file -> <project>\dist\Setup.exe
OutputDir=..\..\dist
OutputBaseFilename=Setup
SetupIconFile=..\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
; 64-bit only (Flutter Windows desktop ships x64).
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
; Needed to write to Program Files.
PrivilegesRequired=admin

[Languages]
Name: "arabic"; MessagesFile: "compiler:Languages\Arabic.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; The entire Release folder: Runner exe, flutter_windows.dll, every plugin DLL,
; and the data\ bundle (flutter_assets, icudtl.dat). recursesubdirs keeps the
; data\ tree; ignoreversion makes upgrades always overwrite app binaries.
Source: "{#BuildDir}\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion

[Icons]
; Start-menu shortcut.
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
; Desktop shortcut — created by DEFAULT (the task below is pre-checked), so the
; user does not have to tick anything.
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
; Optional "Uninstall" entry inside the Start-menu group.
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Tasks]
; Pre-checked by default (no `unchecked` flag) => desktop icon is created
; automatically unless the user explicitly unticks it.
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Run]
; Offer to launch the app at the end of a non-silent install.
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent

; ---------------------------------------------------------------------------
; USER DATA IS PRESERVED on update / reinstall / uninstall:
; the app stores its local data (Drift DB, secure storage, preferences) under
; %APPDATA%\com.saydaliati\, which lives OUTSIDE {app}. This installer only
; ever writes to / removes {app} (Program Files), so that data is never
; touched. There is deliberately NO [UninstallDelete] entry for %APPDATA%.
; ---------------------------------------------------------------------------
