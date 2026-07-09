import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_id_collect/views/card_preview/pdf_service.dart';
import 'package:screenshot/screenshot.dart';

import '../card_send/send_card_view.dart';
import '../select_school/select_school_view.dart';
import '../stud_info/student_info_view.dart';

class DeliPreviewCardView extends StatefulWidget {
  final Map<String, dynamic> studentData;

  const DeliPreviewCardView({super.key, required this.studentData});


  @override
  State<DeliPreviewCardView> createState() => _DeliPreviewCardViewState();
}

class _DeliPreviewCardViewState extends State<DeliPreviewCardView> {
  bool _isGeneratingPDF = false;

  static const double baseCardWidth = 340;
  static const double baseCardHeight = 400;

  final ScreenshotController _frontController = ScreenshotController();
  final ScreenshotController _backController = ScreenshotController();


  Future<(Uint8List, Uint8List)> captureCards() async {

    await Future.delayed(const Duration(milliseconds: 500));

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student ID Card Preview"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // FRONT SIDE
            // FRONT SIDE
            Screenshot(
              controller: _frontController,
              child: _buildFrontCard(),
            ),

            const SizedBox(height: 30),

// BACK SIDE
            Screenshot(
              controller: _backController,
              child: _buildBackCard(),
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
      ),
    );
  }


  Widget _buildFrontCard() {

    final student = widget.studentData;

    return Container(
      width: 350,
      height: 470,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: Stack(
          children: [

            Positioned(
              top: -45,
              left: 0,
              right: -20,
              child: ClipPath(
                clipper: WaveClipperTwo(flip: true),
                child: Container(
                  height: 110,
                  color: const Color(0xffFFC51A), // yellow back layer
                ),
              ),
            ),


// Top Wave Background Layer 2
            Positioned(
              top: -45,
              left: 0,
              right: -20,
              child: ClipPath(
                clipper: WaveClipperTwo(flip: true),
                child: Container(
                  height: 100,
                  color: const Color(0xffEF3E3E), // red front layer
                ),
              ),
            ),


            // Bottom Wave Background Layer 1
            Positioned(
              bottom: -50,
              left: -70,
              right: 0,
              child: ClipPath(
                clipper: WaveClipperTwo(reverse: true),
                child: Container(
                  height: 110,
                  color: const Color(0xffFFC51A), // light teal back layer
                ),
              ),
            ),


// Bottom Wave Background Layer 2
            Positioned(
              bottom: -45,
              left: -70,
              right: 0,
              child: ClipPath(
                clipper: WaveClipperTwo(reverse: true),
                child: Container(
                  height: 95,
                  color: const Color(0xff009494), // dark teal front layer
                ),
              ),
            ),


            // Center Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  CircleAvatar(
                    radius: 30,
                    child:  Image.asset(
                      "assets/icon/deli_icon.png",
                    ),
                  ),


                  const SizedBox(height: 10),


                  const Text(
                    "DELHI PUBLIC SCHOOL",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  const SizedBox(height: 20),


                  CircleAvatar(
                    radius: 55,
                    backgroundImage: widget.studentData["photoPath"] != null &&
                        File(widget.studentData["photoPath"]).existsSync()
                        ? FileImage(
                      File(widget.studentData["photoPath"]),
                    )
                        : const AssetImage(
                      "assets/images/hint_image.png",
                    ) as ImageProvider,
                  ),


                  const SizedBox(height: 15),


                  Text(
                    "Student ID: ${student["rollNumber"] ?? "DIS-00125"}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),


                  const SizedBox(height: 6),


                  Text(
                    "Name: ${student["studentName"] ?? ""}",
                    style: const TextStyle(fontSize: 16),
                  ),


                  const SizedBox(height: 6),


                  Text(
                    "Father Name: ${student["fatherName"] ?? ""}",
                    style: const TextStyle(fontSize: 16),
                  ),


                  const SizedBox(height: 6),


                  Text(
                    "Class / Section: ${student["class"] ?? ""} / ${student["section"] ?? ""}",
                    style: const TextStyle(fontSize: 16),
                  ),


                  const SizedBox(height: 6),


                  Text(
                    "Roll Number: ${student["rollNumber"] ?? ""}",
                    style: const TextStyle(fontSize: 16),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget _buildBackCard() {
    return Container(
      width: 350,
      height: 470,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: Stack(
          children: [

            // TOP YELLOW LAYER
            Positioned(
              top: -45,
              left: 0,
              right: -20,
              child: ClipPath(
                clipper: WaveClipperTwo(flip: true),
                child: Container(
                  height: 110,
                  color: const Color(0xffFFC51A),
                ),
              ),
            ),


            // TOP RED LAYER
            Positioned(
              top: -45,
              left: 0,
              right: -20,
              child: ClipPath(
                clipper: WaveClipperTwo(flip: true),
                child: Container(
                  height: 100,
                  color: const Color(0xffEF3E3E),
                ),
              ),
            ),


            // BOTTOM YELLOW LAYER
            Positioned(
              bottom: -50,
              left: -70,
              right: 0,
              child: ClipPath(
                clipper: WaveClipperTwo(reverse: true),
                child: Container(
                  height: 110,
                  color: const Color(0xffFFC51A),
                ),
              ),
            ),


            // BOTTOM TEAL LAYER
            Positioned(
              bottom: -45,
              left: -70,
              right: 0,
              child: ClipPath(
                clipper: WaveClipperTwo(reverse: true),
                child: Container(
                  height: 95,
                  color: const Color(0xff009494),
                ),
              ),
            ),


            // YOUR EXISTING CONTENT (same position)
            Padding(
              padding: const EdgeInsets.all(30),

              child: Stack(
                children: [

                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Container(
                          color: const Color(0xff0B0854),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          child: const Text(
                            "MESS",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),


                        const SizedBox(height: 5),


                        const Text(
                          "001 211 443 233",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),


                        const SizedBox(height: 30),


                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          color: const Color(0xff0B0854),

                          child: const Text(
                            "SCHOOL ADDRESS",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),


                        const SizedBox(height: 15),


                        const Text(
                          "100/141 Street lane\nMumbai, City lane, New york\nMumbai India",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),

                      ],
                    ),
                  ),


                  // Signature stays bottom right
                  Positioned(
                    right: 0,
                    bottom: 10,

                    child: Column(
                      children: [

                        const SizedBox(
                          width: 120,
                          child: Divider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),

                        const Text(
                          "Principal Signature",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}