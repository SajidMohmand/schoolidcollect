import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_id_collect/views/select_school/select_school_view.dart';

class SendSuccessView extends StatelessWidget {
  const SendSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Divider(),
            SizedBox(height: 80),
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Top
                Positioned(top: -22, child: _bubble(6, 18)),
                Positioned(top: -14, left: 28, child: _bubble(5, 14)),
                Positioned(top: -14, right: 28, child: _bubble(5, 14)),

                // Left
                Positioned(left: -22, child: _bubble(18, 6)),
                Positioned(left: -14, top: 28, child: _bubble(14, 5)),
                Positioned(left: -14, bottom: 28, child: _bubble(14, 5)),

                // Right
                Positioned(right: -22, child: _bubble(18, 6)),
                Positioned(right: -14, top: 28, child: _bubble(14, 5)),
                Positioned(right: -14, bottom: 28, child: _bubble(14, 5)),

                // Bottom
                Positioned(bottom: -22, child: _bubble(6, 18)),
                Positioned(bottom: -14, left: 28, child: _bubble(5, 14)),
                Positioned(bottom: -14, right: 28, child: _bubble(5, 14)),

                // Small dots
                Positioned(top: 6, left: 6, child: _dot(6)),
                Positioned(top: 6, right: 6, child: _dot(6)),
                Positioned(bottom: 6, left: 6, child: _dot(6)),
                Positioned(bottom: 6, right: 6, child: _dot(6)),

                // Main Circle
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xff2C9E3F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.done_rounded,
                    color: Colors.white,
                    size: 55,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Send successfully!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 18),

            const Text(
              "Your ID card has been\nsent to the printing partner\nsuccessfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery Method",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "WhatsApp",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  SizedBox(height: 6),

                  Text("+91 98765 43210", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff038F78),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectSchoolView(),
                    ),
                        (route) => false,
                  );
                  // Done action
                },
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectSchoolView(),
                    ),
                        (route) => false,
                  );
                  // Create another ID card action
                },
                child: const Text(
                  "Create another ID card",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _bubble(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xff2C9E3F),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  Widget _dot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xff2C9E3F),
        shape: BoxShape.circle,
      ),
    );
  }

}
