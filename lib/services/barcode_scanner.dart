import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Turns a USB/Bluetooth HID barcode scanner into a clean [Stream<String>].
///
/// HID scanners emulate a keyboard: they send each character of the barcode
/// very quickly (well under [_maxGapMs] between keystrokes), then terminate
/// with Enter or Tab. This service collects those keystrokes, distinguishes
/// them from normal typing by their speed, and emits the complete code.
///
/// Physical key positions are mapped to QWERTY characters so the service works
/// regardless of the OS keyboard layout (Arabic, French, …). The scanner
/// always sends the physical scan code for each character.
///
/// **Usage:** wrap scanning screens with [BarcodeScannerListener]; or subscribe
/// directly to [scans]. In debug mode call [debugScan] to inject a fake scan.
class BarcodeScannerService {
  BarcodeScannerService._();

  static final BarcodeScannerService instance = BarcodeScannerService._();

  final StreamController<String> _ctrl = StreamController<String>.broadcast();

  /// Emits each complete, validated barcode string.
  Stream<String> get scans => _ctrl.stream;

  final StringBuffer _buf = StringBuffer();
  DateTime _lastAt = DateTime.fromMillisecondsSinceEpoch(0);

  // Maximum gap in ms between keystrokes of the same scan burst.
  static const int _maxGapMs = 80;
  // Minimum barcode length to emit (filters spurious single-key events).
  static const int _minLength = 3;

  bool _registered = false;

  void _ensureRegistered() {
    if (_registered) return;
    _registered = true;
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final now = DateTime.now();
    final gap = now.difference(_lastAt).inMilliseconds;
    _lastAt = now;

    final key = event.physicalKey;

    // Terminators — emit the accumulated buffer.
    if (key == PhysicalKeyboardKey.enter ||
        key == PhysicalKeyboardKey.numpadEnter ||
        key == PhysicalKeyboardKey.tab) {
      final code = _buf.toString().trim();
      _buf.clear();
      if (code.length >= _minLength) _ctrl.add(code);
      return false; // never swallow Enter/Tab — forms still need them
    }

    // Gap too large → manual typing, not a scanner burst; reset state.
    if (gap > _maxGapMs && _buf.isNotEmpty) _buf.clear();

    final ch = _physicalToChar(key);
    if (ch != null) {
      _buf.write(ch);
    } else if (_buf.isNotEmpty) {
      // Unknown key mid-sequence (Shift, Ctrl, dead-key…) → abort this burst.
      _buf.clear();
    }
    return false; // never consume keystrokes
  }

  /// Maps a physical key position to its QWERTY character, ignoring the OS
  /// keyboard layout. Only covers characters used in common barcode symbologies
  /// (EAN-8/13, UPC-A/E, Code128, Code39, CODABAR, ITF).
  static String? _physicalToChar(PhysicalKeyboardKey k) {
    // ── Digits (main row) ──────────────────────────────────────────────────
    if (k == PhysicalKeyboardKey.digit0) return '0';
    if (k == PhysicalKeyboardKey.digit1) return '1';
    if (k == PhysicalKeyboardKey.digit2) return '2';
    if (k == PhysicalKeyboardKey.digit3) return '3';
    if (k == PhysicalKeyboardKey.digit4) return '4';
    if (k == PhysicalKeyboardKey.digit5) return '5';
    if (k == PhysicalKeyboardKey.digit6) return '6';
    if (k == PhysicalKeyboardKey.digit7) return '7';
    if (k == PhysicalKeyboardKey.digit8) return '8';
    if (k == PhysicalKeyboardKey.digit9) return '9';
    // ── Numpad digits ──────────────────────────────────────────────────────
    if (k == PhysicalKeyboardKey.numpad0) return '0';
    if (k == PhysicalKeyboardKey.numpad1) return '1';
    if (k == PhysicalKeyboardKey.numpad2) return '2';
    if (k == PhysicalKeyboardKey.numpad3) return '3';
    if (k == PhysicalKeyboardKey.numpad4) return '4';
    if (k == PhysicalKeyboardKey.numpad5) return '5';
    if (k == PhysicalKeyboardKey.numpad6) return '6';
    if (k == PhysicalKeyboardKey.numpad7) return '7';
    if (k == PhysicalKeyboardKey.numpad8) return '8';
    if (k == PhysicalKeyboardKey.numpad9) return '9';
    // ── Letters A–Z (Code39, Code128 use uppercase) ───────────────────────
    if (k == PhysicalKeyboardKey.keyA) return 'A';
    if (k == PhysicalKeyboardKey.keyB) return 'B';
    if (k == PhysicalKeyboardKey.keyC) return 'C';
    if (k == PhysicalKeyboardKey.keyD) return 'D';
    if (k == PhysicalKeyboardKey.keyE) return 'E';
    if (k == PhysicalKeyboardKey.keyF) return 'F';
    if (k == PhysicalKeyboardKey.keyG) return 'G';
    if (k == PhysicalKeyboardKey.keyH) return 'H';
    if (k == PhysicalKeyboardKey.keyI) return 'I';
    if (k == PhysicalKeyboardKey.keyJ) return 'J';
    if (k == PhysicalKeyboardKey.keyK) return 'K';
    if (k == PhysicalKeyboardKey.keyL) return 'L';
    if (k == PhysicalKeyboardKey.keyM) return 'M';
    if (k == PhysicalKeyboardKey.keyN) return 'N';
    if (k == PhysicalKeyboardKey.keyO) return 'O';
    if (k == PhysicalKeyboardKey.keyP) return 'P';
    if (k == PhysicalKeyboardKey.keyQ) return 'Q';
    if (k == PhysicalKeyboardKey.keyR) return 'R';
    if (k == PhysicalKeyboardKey.keyS) return 'S';
    if (k == PhysicalKeyboardKey.keyT) return 'T';
    if (k == PhysicalKeyboardKey.keyU) return 'U';
    if (k == PhysicalKeyboardKey.keyV) return 'V';
    if (k == PhysicalKeyboardKey.keyW) return 'W';
    if (k == PhysicalKeyboardKey.keyX) return 'X';
    if (k == PhysicalKeyboardKey.keyY) return 'Y';
    if (k == PhysicalKeyboardKey.keyZ) return 'Z';
    // ── Special characters used in barcodes ───────────────────────────────
    if (k == PhysicalKeyboardKey.minus) return '-';
    if (k == PhysicalKeyboardKey.equal) return '+';
    if (k == PhysicalKeyboardKey.slash) return '/';
    if (k == PhysicalKeyboardKey.period) return '.';
    if (k == PhysicalKeyboardKey.space) return ' ';
    return null;
  }

  /// Injects a fake scan for testing without hardware.
  /// Only active in debug builds (guarded by [assert]).
  void debugScan(String code) {
    assert(() {
      if (code.trim().length >= _minLength) _ctrl.add(code.trim());
      return true;
    }());
  }
}

/// Wraps [child] and forwards each scan from [BarcodeScannerService] to
/// [onScan], **only** when this widget is on the currently active route AND
/// the current navigation branch is visible (so inactive POS/catalog tabs
/// don't accidentally handle a scan meant for the foreground tab).
class BarcodeScannerListener extends StatefulWidget {
  const BarcodeScannerListener({
    required this.onScan,
    required this.child,
    super.key,
  });

  final ValueChanged<String> onScan;
  final Widget child;

  @override
  State<BarcodeScannerListener> createState() =>
      _BarcodeScannerListenerState();
}

class _BarcodeScannerListenerState extends State<BarcodeScannerListener> {
  StreamSubscription<String>? _sub;

  @override
  void initState() {
    super.initState();
    BarcodeScannerService.instance._ensureRegistered();
    _sub = BarcodeScannerService.instance.scans.listen(_onScan);
  }

  void _onScan(String code) {
    if (!mounted) return;
    // Inactive route (dialog/new page on top): don't handle.
    if (ModalRoute.of(context)?.isCurrent == false) return;
    // Inactive tab in a StatefulShellRoute: tickers are disabled when offstage.
    if (!TickerMode.valuesOf(context).enabled) return;
    widget.onScan(code);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
