import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_id_collect/views/card_upload/upload_card_view.dart';
import 'package:flutter/services.dart';


class StudentInfoView extends StatefulWidget {
  final Map<String, dynamic> school;
  final Map<String, dynamic>? initialData;

  const StudentInfoView({
    super.key,
    required this.school,
    this.initialData,
  });
  @override
  State<StudentInfoView> createState() => _StudentInfoViewState();
}

class _StudentInfoViewState extends State<StudentInfoView> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final fatherController = TextEditingController();
  final rollController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  final mobileController = TextEditingController();
  final emergencyController = TextEditingController();

  String? selectedClass;
  String? selectedSection;
  String? selectedBlood;

  final classes = ["1", "2", "3", "4", "5", "6"];
  final sections = ["A", "B", "C"];
  final bloodGroups = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+"];

  bool get isFormValid {
    return nameController.text.isNotEmpty &&
        fatherController.text.isNotEmpty &&
        rollController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        emergencyController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        selectedClass != null &&
        selectedSection != null &&
        selectedBlood != null;
  }

  @override
  void initState() {
    super.initState();

    final data = widget.initialData;
    if (data != null) {
      nameController.text = data["studentName"] ?? "";
      fatherController.text = data["fatherName"] ?? "";
      rollController.text = data["rollNumber"] ?? "";
      addressController.text = data["address"] ?? "";
      dobController.text = data["dob"] ?? "";
      mobileController.text = data["mobile"] ?? "";
      emergencyController.text = data["emergencyContact"] ?? "";
      selectedClass = data["class"];
      selectedSection = data["section"];
      selectedBlood = data["bloodGroup"];
    }

    nameController.addListener(updateState);
    fatherController.addListener(updateState);
    rollController.addListener(updateState);
    addressController.addListener(updateState);
    dobController.addListener(updateState);
    mobileController.addListener(updateState);
    emergencyController.addListener(updateState);
  }

  void updateState() {
    setState(() {});
  }


  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff1D69E6),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text("Student Information",style: TextStyle(color: Color(0xff1D69E6)),),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              size: 28,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Step 1 of 3",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff1D69E6),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 16),

              // Step Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  stepCircle("1", true),
                  stepLine(),
                  stepCircle("2", false),
                  stepLine(),
                  stepCircle("3", false),
                ],
              ),

              const SizedBox(height: 25),

              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      customField(
                        controller: nameController,
                        hint: "Student Name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Student name is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      customField(
                        controller: fatherController,
                        hint: "Father Name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Father name is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      LayoutBuilder(
                        builder: (context, constraints) {

                          return Row(
                            children: [

                              Expanded(
                                child: dropdownWithLabel(
                                  title: "Class",
                                  value: selectedClass,
                                  items: classes,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedClass = value;
                                    });
                                  },
                                ),
                              ),


                              SizedBox(
                                width: constraints.maxWidth < 350 ? 6 : 12,
                              ),


                              Expanded(
                                child: dropdownWithLabel(
                                  title: "Section",
                                  value: selectedSection,
                                  items: sections,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedSection = value;
                                    });
                                  },
                                ),
                              ),

                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 14),

                      customField(
                        controller: rollController,
                        hint: "Roll Number",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Roll number is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Date of Birth *",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: dobController,
                            readOnly: true,
                            onTap: selectDate,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Date of birth is required";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Select Date of Birth",
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      customField(
                        controller: mobileController,
                        hint: "Mobile Number",
                        keyboardType: TextInputType.phone,
                        prefixText: "+91 ",
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Mobile number is required";
                          }
                          final indianMobileRegex = RegExp(r'^[6-9]\d{9}$');
                          if (!indianMobileRegex.hasMatch(value.trim())) {
                            return "Enter a valid 10-digit Indian mobile number";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      customField(
                        controller: emergencyController,
                        hint: "Emergency Contact",
                        keyboardType: TextInputType.phone,
                        prefixText: "+91 ",
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Emergency contact is required";
                          }
                          final indianMobileRegex = RegExp(r'^[6-9]\d{9}$');
                          if (!indianMobileRegex.hasMatch(value.trim())) {
                            return "Enter a valid 10-digit Indian mobile number";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      optionDropdown(
                        title: "Blood Group",
                        value: selectedBlood,
                        items: bloodGroups,
                        onChanged: (value) {
                          setState(() {
                            selectedBlood = value;
                          });
                        },
                      ),

                      const SizedBox(height: 14),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Address *",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: addressController,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Address is required";
                          }
                          if (value.trim().length < 5) {
                            return "Enter a complete address";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Address *",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isFormValid
                      ? () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    final studentData = {
                      "school": widget.school,
                      "studentName": nameController.text.trim(),
                      "fatherName": fatherController.text.trim(),
                      "class": selectedClass,
                      "section": selectedSection,
                      "rollNumber": rollController.text.trim(),
                      "dob": dobController.text.trim(),
                      "mobile": mobileController.text.trim(),
                      "emergencyContact": emergencyController.text.trim(),
                      "bloodGroup": selectedBlood,
                      "address": addressController.text.trim(),
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UploadCardView(
                          studentData: studentData,
                        ),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff038D76),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 18,
                      color: isFormValid
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget stepCircle(String text, bool active) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: active
          ? const Color(0xff1D69E6)
          : Colors.grey.shade300,
      child: Text(
        text,
        style: TextStyle(
          color: active
              ? Colors.white
              : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget dropdownWithLabel({
    required String title,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title *",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: value,
          hint: Text("Select $title", style: TextStyle(
            color: Colors.grey.shade600,
          )),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          menuMaxHeight: 250,
          validator: (value) {
            if (value == null) {
              return "$title is required";
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget stepLine() {
    return Container(
      width: 50,
      height: 2,
      color: Colors.grey.shade300,
    );
  }


  Widget customField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? prefixText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$hint *",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: "Enter $hint",
            prefixText: prefixText,
            prefixStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget optionDropdown({
    required String title,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: value,
          hint: Text("Select $title"),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          menuMaxHeight: 250,
          validator: (value) {
            if (value == null) {
              return "$title is required";
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }


  @override
  void dispose() {
    nameController.dispose();
    fatherController.dispose();
    rollController.dispose();
    addressController.dispose();
    dobController.dispose();
    mobileController.dispose();
    emergencyController.dispose();
    super.dispose();
  }
}