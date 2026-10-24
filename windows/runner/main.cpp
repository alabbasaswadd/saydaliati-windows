#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  // محرّك الرسم: Skia افتراضاً، لا Impeller.
  //
  // صار Impeller افتراضَ فلاتر على ويندوز، وهو يعتمد على Vulkan. وكروت
  // الرسوميات المدمجة القديمة (Intel HD وأمثالها بتعريفات لم تُحدَّث)
  // تُعلن دعمه ثم تفشل في العرض بصمت: نافذةٌ سوداء تماماً، بينما يبقى كل
  // شيءٍ آخر سليماً — التخطيط يعمل، والفأرة تعمل، والمؤشّر يتغيّر فوق
  // الحقول، ولا استثناء ولا رسالة. أسوأ أنواع الأعطال: لا شيء يدلّ عليه.
  //
  // وSkia هو ما عمل عليه التطبيق طوال عمره، والفارق في الأداء لا يُلحَظ في
  // تطبيق إدارةٍ كهذا — بينما الفارق في التوافق هو الفرق بين أن يعمل
  // البرنامج على جهاز الصيدلية أو لا يعمل أصلاً.
  //
  // ومَن أراد Impeller (جهازٌ حديث، أداءٌ أفضل) يضبط
  // SAYDALIATI_IMPELLER=1 — فالخيار محفوظ ولم يُغلَق.
  wchar_t impeller_env[8] = {0};
  const DWORD impeller_len = ::GetEnvironmentVariableW(
      L"SAYDALIATI_IMPELLER", impeller_env, 8);
  const bool want_impeller =
      impeller_len > 0 && impeller_env[0] == L'1';
  project.set_impeller_switch(want_impeller
                                  ? flutter::ImpellerSwitch::Enabled
                                  : flutter::ImpellerSwitch::Disabled);

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"saydaliati", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
