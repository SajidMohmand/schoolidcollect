import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<File> createPdf(
    Uint8List front,
    Uint8List back,
    ) async {

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (_) => pw.Center(
        child: pw.Image(
          pw.MemoryImage(front),
        ),
      ),
    ),
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (_) => pw.Center(
        child: pw.Image(
          pw.MemoryImage(back),
        ),
      ),
    ),
  );

  final dir = await getTemporaryDirectory();

  final file = File("${dir.path}/student_card.pdf");

  await file.writeAsBytes(await pdf.save());

  return file;
}