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
; مُثبِّت Microsoft الرسميّ لمكتبات التشغيل (Visual C++ 2015-2022 x64).
; يُجهَّز في هذا المسار بواسطة scripts\build_windows_installer.ps1: يُنسَخ من
; تثبيت Visual Studio المحلّي إن وُجد، وإلّا يُنزَّل من رابط مايكروسوفت
; الرسميّ (aka.ms) ويُتحقَّق من توقيعه قبل الاستعمال.
#define VCRedistDir "..\..\build\redist"
#define VCRedistExe "vc_redist.x64.exe"

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
; مكتبات تشغيل C++ — تُستخرَج مؤقّتاً وتُشغَّل قبل نسخ ملفات التطبيق.
;
; `dontcopy` لأن تثبيتها يجري من [Code] لا بنسخها إلى مجلّد التطبيق.
Source: "{#VCRedistDir}\{#VCRedistExe}"; Flags: dontcopy

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

[Code]
// ───────────────────────────────────────────────────────────────────────────
//  مكتبات تشغيل Visual C++
//
//  تطبيق Flutter لويندوز يُبنى بـMSVC ويرتبط ديناميكياً بـ
//  VCRUNTIME140.dll و VCRUNTIME140_1.dll و MSVCP140.dll. وهذه **ليست جزءاً
//  من ويندوز**: جهاز المستخدم النظيف لا يملكها، فيُقلع التطبيق برسالة
//  «VCRUNTIME140_1.dll was not found» ويموت قبل أن يرسم شيئاً.
//
//  (أمّا api-ms-win-crt-* فهي الـUniversal CRT وتأتي مع ويندوز 10 فصاعداً.)
//
//  الحلّ: تشغيل مُثبِّت مايكروسوفت الرسميّ بصمت عند الحاجة — لا نسخُ DLL
//  يدوياً إلى System32، فذلك يكسر تحديثات الأمان ويُفسد تطبيقاتٍ أخرى.
// ───────────────────────────────────────────────────────────────────────────

const
  VCRuntimeKey = 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\X64';
  // 29325 = إصدار VS 2019 16.8؛ أقدم منه قد يفتقد VCRUNTIME140_1.dll.
  VCRuntimeMinBuild = 29325;

function VCRuntimeInstalled: Boolean;
var
  installed, bld: Cardinal;
begin
  Result := False;

  // المفتاح يُكتَب في المَشهدين (مُثبِّت الحزمة 32-بت)، فيُقرأ الاثنان.
  if RegQueryDWordValue(HKEY_LOCAL_MACHINE, VCRuntimeKey, 'Installed', installed)
     or RegQueryDWordValue(HKEY_LOCAL_MACHINE_32, VCRuntimeKey, 'Installed', installed) then
  begin
    if installed = 1 then
    begin
      if not RegQueryDWordValue(HKEY_LOCAL_MACHINE, VCRuntimeKey, 'Bld', bld) then
        RegQueryDWordValue(HKEY_LOCAL_MACHINE_32, VCRuntimeKey, 'Bld', bld);
      Result := bld >= VCRuntimeMinBuild;
    end;
  end;

  // تحقّقٌ من الواقع لا من السجلّ وحده: مفتاحٌ باقٍ بعد حذفٍ ناقص يجعل
  // المُثبِّت يتخطّى الخطوة ويُسلّم تطبيقاً لا يُقلع.
  if Result and (not FileExists(ExpandConstant('{sys}\VCRUNTIME140_1.dll'))) then
    Result := False;
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  code: Integer;
begin
  Result := '';
  if VCRuntimeInstalled then
    Exit;

  ExtractTemporaryFile('{#VCRedistExe}');

  if not Exec(ExpandConstant('{tmp}\{#VCRedistExe}'),
              '/install /passive /norestart', '',
              SW_SHOW, ewWaitUntilTerminated, code) then
  begin
    Result := 'تعذّر تشغيل مُثبِّت مكتبات Microsoft Visual C++.';
    Exit;
  end;

  // 0 = تمّ، 1638 = نسخة أحدث موجودة، 3010 = يحتاج إعادة تشغيل.
  if code = 3010 then
    NeedsRestart := True
  else if (code <> 0) and (code <> 1638) then
    Result := 'فشل تثبيت مكتبات Microsoft Visual C++ (رمز ' + IntToStr(code) + ').'
              + #13#10 + 'التطبيق لن يعمل بدونها — أعد المحاولة أو ثبّتها يدوياً.';
end;

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
