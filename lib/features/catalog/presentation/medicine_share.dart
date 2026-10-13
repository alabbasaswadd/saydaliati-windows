import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:saydaliati/features/catalog/domain/catalog_item.dart';
import 'package:saydaliati/features/catalog/presentation/medicine_pdf.dart';

/// Captures the medicine card (wrapped in a RepaintBoundary with [boundaryKey])
/// as a PNG and opens the share sheet — "share the normal medicine view".
Future<void> shareMedicineAsImage(GlobalKey boundaryKey, String name) async {
  final boundary =
      boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) return;
  final image = await boundary.toImage(pixelRatio: 2.5);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  if (data == null) return;
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/medicine_${DateTime.now().millisecondsSinceEpoch}.png');
  await file.writeAsBytes(data.buffer.asUint8List());
  await Share.shareXFiles([XFile(file.path)], subject: name, text: 'بطاقة دواء — صيدليتي');
}

/// Builds and shares a full PDF of the medicine + its alternatives (branded,
/// with a QR to our site).
Future<void> shareMedicineAsPdf(
  CatalogItem item,
  List<CatalogItem> alternatives,
) async {
  final bytes = await buildMedicinePdf(item, alternatives);
  final name = item.sakoCode.isNotEmpty ? item.sakoCode : item.id;
  await Printing.sharePdf(bytes: bytes, filename: 'saydaliati-medicine-$name.pdf');
}
