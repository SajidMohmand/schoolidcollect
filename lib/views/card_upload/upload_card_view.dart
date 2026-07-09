import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_id_collect/views/card_preview/deli_preview_card_view.dart';
import 'package:school_id_collect/views/card_preview/preview_card_screen.dart';

import '../repository/card_screen_factory.dart';

class UploadCardView extends StatefulWidget {
  final Map<String, dynamic> studentData;

  const UploadCardView({
    super.key,
    required this.studentData,
  });
  @override
  State<UploadCardView> createState() => _UploadCardViewState();
}

class _UploadCardViewState extends State<UploadCardView> {
  File? selectedImage;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final existingPhoto = widget.studentData["photoPath"];
    if (existingPhoto != null) {
      selectedImage = File(existingPhoto);
    }
  }


  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Upload Photo",
          style: TextStyle(
            color: Color(0xff6441BC),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Step 2 of 3",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff6441BC),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    stepCircle("1", false),
                    stepLine(),
                    stepCircle("2", true),
                    stepLine(),
                    stepCircle("3", false),
                  ],
                ),

                const SizedBox(height: 35),

                Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: selectedImage == null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/images/hint_image.png",
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        ),
                ),

                const SizedBox(height: 15),

                const Text("Passport size photo", style: TextStyle(fontSize: 16)),

                const SizedBox(height: 40),

                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        pickImage(ImageSource.camera);
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 22,
                        color: Color(0xff09b0b6),
                      ),
                      label: const Text(
                        "Take Photo",
                        style: TextStyle(fontSize: 18, color: Color(0xff09b0b6)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xff09b0b6), // Border color
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(
                        Icons.photo_library_outlined,
                        size: 22,
                        color: Color(0xff09b0b6),
                      ),
                      label: const Text(
                        "Choose From Gallery",
                        style: TextStyle(fontSize: 18, color: Color(0xff09b0b6)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xff09b0b6), // Border color
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: selectedImage == null
                        ? null
                        : () {
                      final completeStudentData = {
                        ...widget.studentData,
                        "photoPath": selectedImage!.path,
                      };

                      final schoolName = widget.studentData['school']['name'];

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CardScreenFactory.getScreen(
                            schoolName,
                            completeStudentData,
                          ),
                        ),
                      );

                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6441BC),
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 18,
                        color: selectedImage == null ? Colors.grey : Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget stepCircle(String text, bool active) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: active ? const Color(0xff6441BC) : Colors.grey.shade300,

      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget stepLine() {
    return Container(width: 50, height: 2, color: Colors.grey.shade300);
  }
}
