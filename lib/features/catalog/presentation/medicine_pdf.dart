import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:saydaliati/features/catalog/domain/catalog_item.dart';

/// Our public site — encoded as a QR on the shared PDF.
const String _siteUrl = 'https://codetechsyria.com/saydaliati';
const PdfColor _brand = PdfColor.fromInt(0xFF0E7C66); // صيدليتي teal-green

/// Builds a clean, readable A4 PDF for a catalog medicine: Saydaliati brand
/// header (logo + name), full drug details, its alternatives, and a footer with
/// a QR to our site. Arabic is laid out RTL using the Cairo font (PdfGoogleFonts).
Future<Uint8List> buildMedicinePdf(
  CatalogItem item,
  List<CatalogItem> alternatives,
) async {
  final regular = await PdfGoogleFonts.cairoRegular();
  final bold = await PdfGoogleFonts.cairoBold();
  final nf = NumberFormat('#,##0.##');
  String money(num v, String symbol) =>
      v > 0 ? '${nf.format(v)} $symbol' : 'غير مسعّر';

  pw.MemoryImage? logo;
  try {
    final bytes = await rootBundle.load('assets/icon/app_icon.png');
    logo = pw.MemoryImage(bytes.buffer.asUint8List());
  } catch (_) {/* logo optional */}

  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      textDirection: pw.TextDirection.rtl,
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(base: regular, bold: bold),
      build: (context) => [
        // ---- Brand header (solid banner: logo + صيدليتي in white) ----
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const pw.BoxDecoration(
            color: _brand,
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(12)),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (logo != null)
                pw.Container(
                  width: 50,
                  height: 50,
                  padding: const pw.EdgeInsets.all(5),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.white,
                    shape: pw.BoxShape.circle,
                  ),
                  child: pw.Image(logo),
                ),
              if (logo != null) pw.SizedBox(width: 12),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('صيدليتي',
                      style: pw.TextStyle(font: bold, fontSize: 22, color: PdfColors.white)),
                  pw.Text('بطاقة دواء من الكاتلوغ',
                      style: pw.TextStyle(
                          font: regular, fontSize: 11, color: PdfColor.fromInt(0xFFD9F0EA))),
                ],
              ),
              pw.Spacer(),
              pw.Text(DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  style: pw.TextStyle(font: regular, fontSize: 10, color: PdfColors.white)),
            ],
          ),
        ),
        pw.SizedBox(height: 16),

        // ---- Medicine name ----
        pw.Text(item.displayName, style: pw.TextStyle(font: bold, fontSize: 18)),
        if (item.foreignName.isNotEmpty && item.foreignName != item.brandName)
          pw.Text(item.foreignName,
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
        pw.SizedBox(height: 10),

        // ---- Details ----
        _detailsTable(bold, item, money),

        pw.SizedBox(height: 18),

        // ---- Alternatives ----
        pw.Text('البدائل (نفس المادة الفعّالة)',
            style: pw.TextStyle(font: bold, fontSize: 14, color: _brand)),
        pw.SizedBox(height: 6),
        if (alternatives.isEmpty)
          pw.Text('لا توجد بدائل مسجّلة.',
              style: const pw.TextStyle(color: PdfColors.grey700))
        else
          pw.TableHelper.fromTextArray(
            headers: ['الاسم', 'الشركة', 'السعر'],
            data: [
              for (final a in alternatives)
                [a.displayName, a.manufacturerName, money(a.pricePublic, a.currencySymbol)],
            ],
            headerStyle: pw.TextStyle(font: bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: _brand),
            cellAlignment: pw.Alignment.centerRight,
            headerAlignment: pw.Alignment.centerRight,
            cellStyle: const pw.TextStyle(fontSize: 10),
            columnWidths: const {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(1.4),
            },
          ),
      ],
      footer: (context) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 10),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: _siteUrl,
              width: 54,
              height: 54,
            ),
            pw.SizedBox(width: 10),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('صيدليتي — إدارة صيدلية ذكية',
                    style: pw.TextStyle(font: bold, fontSize: 10, color: _brand)),
                pw.Text('امسح الرمز لزيارة موقعنا: codetechsyria.com/saydaliati',
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
              ],
            ),
            pw.Spacer(),
            pw.Text('صفحة ${context.pageNumber}/${context.pagesCount}',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
          ],
        ),
      ),
    ),
  );
  return doc.save();
}

pw.Widget _detailsTable(
    pw.Font bold, CatalogItem item, String Function(num, String) money) {
  final rows = <List<String>>[
    if (item.genericName.isNotEmpty) ['المادة الفعّالة / التركيب', item.genericName],
    if (item.manufacturerName.isNotEmpty) ['الشركة', item.manufacturerName],
    if (item.barcode.isNotEmpty) ['الباركود', item.barcode],
    if (item.note.isNotEmpty) ['العبوة', item.note],
    if (item.usage.isNotEmpty) ['الاستخدام', item.usage],
    if (item.dosage.isNotEmpty) ['الجرعة', item.dosage],
    ['السعر', money(item.pricePublic, item.currencySymbol)],
  ];
  return pw.TableHelper.fromTextArray(
    data: rows,
    cellAlignment: pw.Alignment.centerRight,
    border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
    cellStyle: const pw.TextStyle(fontSize: 11),
    columnWidths: const {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(4)},
    cellDecoration: (col, data, row) => col == 0
        ? const pw.BoxDecoration(color: PdfColors.grey100)
        : const pw.BoxDecoration(),
  );
}
