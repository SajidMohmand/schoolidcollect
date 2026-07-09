import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_id_collect/views/card_preview/pdf_service.dart';
import 'package:screenshot/screenshot.dart';

import '../card_send/send_card_view.dart';
import '../select_school/select_school_view.dart';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../stud_info/student_info_view.dart';

class PreviewCardScreen extends StatefulWidget {
  final Map<String, dynamic> studentData;

  const PreviewCardScreen({super.key, required this.studentData});

  @override
  State<PreviewCardScreen> createState() => _PreviewCardScreenState();
}

class _PreviewCardScreenState extends State<PreviewCardScreen> {
  bool _isGeneratingPDF = false;

  static const double baseCardWidth = 340;
  static const double baseCardHeight = 400;

  final ScreenshotController _frontController = ScreenshotController();
  final ScreenshotController _backController = ScreenshotController();


  Future<(Uint8List, Uint8List)> captureCards() async {

    await WidgetsBinding.instance.endOfFrame;
    await Future.delayed(const Duration(milliseconds: 100));

    final front = await _frontController.capture(
      pixelRatio: 4,
    );

    final back = await _backController.capture(
      pixelRatio: 4,
    );

    if (front == null || back == null) {
      throw Exception("Capture failed");
    }

    return (front, back);
  }
  
  Future<void> testCapture() async {

    final (front, back) = await captureCards();

    final dir = await getTemporaryDirectory();

    await File("${dir.path}/front.png").writeAsBytes(front);

    await File("${dir.path}/back.png").writeAsBytes(back);

    print("${dir.path}/front.png");
    print("${dir.path}/back.png");
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            "Preview ID Card",
            style: TextStyle(color: Color(0xff1D69E6)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, size: 28),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Card width = screen width minus body padding, capped at base size
            final cardWidth = (constraints.maxWidth - 32)
                .clamp(0, baseCardWidth)
                .toDouble();
            final cardHeight = cardWidth * (baseCardHeight / baseCardWidth);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Front Side",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Screenshot(
                    controller: _frontController,
                    child: frontCard(context, cardWidth, cardHeight),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Back Side",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Screenshot(
                    controller: _backController,
                    child: backCard(context, cardWidth, cardHeight),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentInfoView(
                                  school: widget.studentData["school"],
                                  initialData: widget.studentData,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55),
                            side: const BorderSide(
                              color: Color(0xff038D76),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Edit Details",
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(0xff038D76),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {

                            setState(() {
                              _isGeneratingPDF = true;
                            });

                            try {

                              final (front, back) = await captureCards();

                              final pdfFile = await createPdf(front, back);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SendCardView(
                                    pdfFile: pdfFile,
                                    studentData: widget.studentData,
                                  ),
                                ),
                              );

                            } finally {

                              setState(() {
                                _isGeneratingPDF = false;
                              });

                            }

                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55),
                            backgroundColor: const Color(0xffF86F00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isGeneratingPDF
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Send To Printer",
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget frontCard(BuildContext context, double cardWidth, double cardHeight) {
    final cornerHeight = cardHeight * 0.62;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
              top: 40,
            ),
            decoration: cardDecoration(),
            child: Column(
              children: [
                Text(
                  widget.studentData["school"]?["name"] ?? "ABC School Name",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Achieving Excellence Together",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xff082846), width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: widget.studentData["photoPath"] != null
                        ? FileImage(File(widget.studentData["photoPath"]))
                              as ImageProvider
                        : const AssetImage("assets/images/hint_image.png"),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: cardWidth * 0.69,
                    child: Column(
                      children: [
                        infoRowFirstCard(
                          "Reg No",
                          widget.studentData["rollNumber"] ?? "",
                        ),
                        infoRowFirstCard(
                          "Father/Guardian",
                          widget.studentData["fatherName"] ?? "",
                        ),
                        infoRowFirstCard(
                          "Class",
                          "${widget.studentData["class"] ?? ""} - ${widget.studentData["section"] ?? ""}",
                        ),
                        infoRowFirstCard(
                          "Emergency Call",
                          widget.studentData["emergencyContact"] ?? "",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              height: cornerHeight * 0.8,
              child: CustomPaint(
                painter: FilledCornerPainter(
                  color: const Color(0xff89cff1),
                  position: CornerPosition.topRight,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: cornerHeight * 0.8,
              child: CustomPaint(
                painter: FilledCornerPainter(
                  color: const Color(0xff89cff1),
                  position: CornerPosition.bottomLeft,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget backCard(BuildContext context, double cardWidth, double cardHeight) {
    final horizontalPadding = cardWidth * 0.12;
    final cornerHeight = cardHeight * 0.62;
    final barcodeWidth = cardWidth * 0.70;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        children: [
          // Main Card
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(
              top: cardHeight * 0.04,
              bottom: cardHeight * 0.04,
              left: horizontalPadding,
              right: horizontalPadding,
            ),
            decoration: cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 4, right: 4),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 4,
                      right: 4,
                      top: 4,
                      bottom: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff89cff1),
                      borderRadius: BorderRadius.circular(4),
                      border: const Border(
                        right: BorderSide(color: Colors.black, width: 2.5),
                        bottom: BorderSide(color: Colors.black, width: 2.5),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "TERMS AND CONDITIONS",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      TextSpan(
                        text: "• ",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Student must carry this card daily. this is important to know.we are here for any hel and gudende, hapy to help you",
                      ),
                    ],
                  ),
                ),

                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      TextSpan(
                        text: "• ",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Card should be returned after leaving school. This is true and must be followed.",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: AlignmentGeometry.center,
                  child: SizedBox(
                    width: cardWidth * 0.58,
                    child: Column(
                      children: [
                        infoRowSecondCard(
                          "Phone",
                          widget.studentData["mobile"] ?? "",
                        ),
                        infoRowSecondCard("Mail", "urmail@gmail.com"),
                        infoRowSecondCard("Website", "www.urweb.com"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Image(
                    image: AssetImage('assets/images/signature.png'),
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: cardWidth * 0.20),
                  child: const Divider(thickness: 1.5, color: Colors.black),
                ),

                const Center(
                  child: Text(
                    "Principle",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Spacer(), // replaces Spacer()

                Center(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: widget.studentData["rollNumber"] ?? "0000",
                      width: barcodeWidth * 0.8,
                      height: cardHeight * 0.06,
                      drawText: false,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),

          // Top Right Corner (filled)
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              height: cornerHeight * 0.8,
              child: CustomPaint(
                painter: FilledCornerPainter(
                  color: const Color(0xff89cff1),
                  position: CornerPosition.topRight,
                ),
              ),
            ),
          ),

          // Bottom Left Corner (filled)
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: cornerHeight * 0.8,
              child: CustomPaint(
                painter: FilledCornerPainter(
                  color: const Color(0xff89cff1),
                  position: CornerPosition.bottomLeft,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRowFirstCard(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, maxLines: 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRowSecondCard(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(2),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

// Filled L-shaped corner accent with rounded edges + border on bottom edge only
class FilledCornerPainter extends CustomPainter {
  final Color color;
  final CornerPosition position;
  final double thickness;
  final double outerRadius;
  final double innerRadius;

  FilledCornerPainter({
    required this.color,
    required this.position,
    this.thickness = 30,
    this.outerRadius = 0,
    this.innerRadius = 18,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()..style = PaintingStyle.stroke;
    switch (position) {
      case CornerPosition.topRight:
        final topBar = RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, size.width, thickness),
          topRight: Radius.circular(outerRadius),
          bottomLeft: Radius.circular(innerRadius),
        );
        final rightBar = RRect.fromRectAndCorners(
          Rect.fromLTWH(size.width - thickness, 0, thickness, size.height),
          topRight: Radius.circular(outerRadius),
          bottomLeft: Radius.circular(innerRadius),
        );

        canvas.drawRRect(topBar, fillPaint);
        canvas.drawRRect(rightBar, fillPaint);

        // Border only on the bottom edge of each bar
        canvas.drawLine(
          Offset(0, thickness - 0.5),
          Offset(size.width, thickness - 0.5),
          borderPaint,
        );
        canvas.drawLine(
          Offset(size.width - thickness, size.height - 0.5),
          Offset(size.width, size.height - 0.5),
          borderPaint,
        );
        break;

      case CornerPosition.bottomLeft:
        final leftBar = RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, thickness, size.height),
          bottomLeft: Radius.circular(outerRadius),
          topRight: Radius.circular(innerRadius),
        );
        final bottomBar = RRect.fromRectAndCorners(
          Rect.fromLTWH(0, size.height - thickness, size.width, thickness),
          bottomLeft: Radius.circular(outerRadius),
          topRight: Radius.circular(innerRadius),
        );

        canvas.drawRRect(leftBar, fillPaint);
        canvas.drawRRect(bottomBar, fillPaint);

        // Border only on the bottom edge (bottom of the left bar + full bottom bar's bottom edge)
        canvas.drawLine(
          Offset(0, size.height - 0.5),
          Offset(size.width, size.height - 0.5),
          borderPaint,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant FilledCornerPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.position != position ||
      oldDelegate.thickness != thickness ||
      oldDelegate.outerRadius != outerRadius ||
      oldDelegate.innerRadius != innerRadius;
}

enum CornerPosition { topRight, bottomLeft }
