import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:saydaliati/core/constants/app_strings.dart';
import 'package:saydaliati/features/sales/domain/entities/sale.dart';

/// Builds a printable/shareable A4 PDF for a sales invoice. Arabic text is laid
/// out RTL using the Cairo font fetched at runtime via [PdfGoogleFonts] (so no
/// font asset needs bundling). Amounts use the sale's stored (base) currency.
Future<Uint8List> buildInvoicePdf(Sale sale, {required String pharmacyName}) async {
  final regular = await PdfGoogleFonts.cairoRegular();
  final bold = await PdfGoogleFonts.cairoBold();
  final nf = NumberFormat('#,##0.##');
  final df = DateFormat('yyyy-MM-dd  HH:mm');
  final code = sale.currencyCode;
  String money(double v) => '${nf.format(v)} $code'.trim();

  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      textDirection: pw.TextDirection.rtl,
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(base: regular, bold: bold),
      build: (context) => [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(pharmacyName.isEmpty ? AppStrings.appName : pharmacyName,
                style: pw.TextStyle(font: bold, fontSize: 18)),
            pw.Text(AppStrings.invoiceDocTitle,
                style: pw.TextStyle(font: bold, fontSize: 16)),
          ],
        ),
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('${AppStrings.invoiceLabel} #${sale.invoiceNumber}'),
            pw.Text('${AppStrings.dateColumn}: ${df.format(sale.saleDate)}'),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.TableHelper.fromTextArray(
          headers: [
            AppStrings.medicineName,
            AppStrings.unitLabel,
            AppStrings.quantity,
            AppStrings.price,
            AppStrings.total,
          ],
          data: [
            for (final l in sale.items)
              [
                l.medicineName,
                l.unitName,
                nf.format(l.quantity),
                nf.format(l.individual),
                nf.format(l.subTotal),
              ],
          ],
          headerStyle: pw.TextStyle(font: bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          cellAlignment: pw.Alignment.center,
          headerAlignment: pw.Alignment.center,
          columnWidths: const {
            0: pw.FlexColumnWidth(3), // الدواء
            1: pw.FlexColumnWidth(2), // الوحدة
            2: pw.FlexColumnWidth(1.1), // الكمية
            3: pw.FlexColumnWidth(1.8), // السعر
            4: pw.FlexColumnWidth(1.9), // الإجمالي
          },
        ),
        pw.SizedBox(height: 14),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.SizedBox(
            width: 240,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(AppStrings.total, style: pw.TextStyle(font: bold, fontSize: 14)),
                pw.Text(money(sale.totalAmount),
                    style: pw.TextStyle(font: bold, fontSize: 14)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
  return doc.save();
}

/// Opens the system share/print sheet for the invoice PDF.
Future<void> shareInvoicePdf(Sale sale, {required String pharmacyName}) async {
  final bytes = await buildInvoicePdf(sale, pharmacyName: pharmacyName);
  await Printing.sharePdf(bytes: bytes, filename: 'invoice-${sale.invoiceNumber}.pdf');
}
