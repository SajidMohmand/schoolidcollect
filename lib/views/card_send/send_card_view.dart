import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:school_id_collect/views/card_send/send_success_view.dart';

// ---------------------------------------------------------------------------
// Printer contact details
// ---------------------------------------------------------------------------
// TODO: double-check this — a Pakistani mobile number is normally
// "+92 3XX XXXXXXX" (12 digits after the +). The number below has 13 digits,
// so there may be an extra "0" in there. Fix if needed.
const String kPrinterEmail = "sajid.muhmand99@gmail.com";
const String kPrinterWhatsApp = "+9203257674043";

class SendCardView extends StatefulWidget {
  final File? pdfFile;
  final Map<String, dynamic>? studentData;

  const SendCardView({
    super.key,
    this.pdfFile,
    this.studentData,
  });
  @override
  State<SendCardView> createState() => _SendCardViewState();
}

class _SendCardViewState extends State<SendCardView> {
  String selectedMethod = "";
  bool isSending = false;

  // ---------------------------------------------------------------------
  // Sending logic
  // ---------------------------------------------------------------------

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xff038D75),
      ),
    );
  }

  /// Sends the PDF as an email attachment to [kPrinterEmail] using the
  /// device's native mail client (Gmail, Outlook, etc). Falls back to the
  /// generic share sheet if no mail client can handle attachments.
  Future<bool> _sendViaEmail() async {
    debugPrint("PDF File: ${widget.pdfFile}");
    debugPrint("PDF Path: ${widget.pdfFile?.path}");
    debugPrint("Exists: ${widget.pdfFile?.existsSync()}");
    if (widget.pdfFile == null || !widget.pdfFile!.existsSync()) {
      _showSnack("PDF file not found.", isError: true);
      return false;
    }

    final studentName = widget.studentData?['name']?.toString() ?? 'Student';

    final email = Email(
      body:
      'Hi,\n\nPlease find attached the ID card for $studentName to be printed.\n\nThanks.',
      subject: 'Student ID Card Print Request - $studentName',
      recipients: [kPrinterEmail],
      attachmentPaths: [widget.pdfFile!.path],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      return true;
    } catch (e) {
      // No mail client configured / attachment not supported on this
      // platform — fall back to the OS share sheet with the recipient
      // pre-filled in the message body as a courtesy.
      try {
        await Share.shareXFiles(
          [XFile(widget.pdfFile!.path)],
          subject: 'Student ID Card Print Request - $studentName',
          text: 'Please send this to $kPrinterEmail for printing.',
        );
        return true;
      } catch (e2) {
        _showSnack("Could not open an email app: $e2", isError: true);
        return false;
      }
    }
  }

  /// WhatsApp has no public API to pre-attach a file to an outgoing chat,
  /// so we do the next best thing: open the native share sheet with the
  /// PDF ready to send, and open the WhatsApp chat for the printer's
  /// number so the user just needs to pick WhatsApp and tap send.
  Future<bool> _sendViaWhatsApp() async {
    debugPrint("PDF File: ${widget.pdfFile}");
    debugPrint("PDF Path: ${widget.pdfFile?.path}");
    debugPrint("Exists: ${widget.pdfFile?.existsSync()}");
    if (widget.pdfFile == null || !widget.pdfFile!.existsSync()) {
      _showSnack("PDF file not found.", isError: true);
      return false;
    }

    final digitsOnly = kPrinterWhatsApp.replaceAll(RegExp(r'[^0-9]'), '');

    // 1. Open the file share sheet so the user can pick WhatsApp directly.
    bool shared = false;
    try {
      final result = await Share.shareXFiles(
        [XFile(widget.pdfFile!.path)],
        text: 'Student ID Card for printing — send to $kPrinterWhatsApp',
      );
      shared = result.status == ShareResultStatus.success ||
          result.status == ShareResultStatus.unavailable;
    } catch (e) {
      shared = false;
    }

    // 2. Also try to open the specific WhatsApp chat with a prefilled
    // message, as a convenience / fallback if the share sheet was
    // dismissed without picking WhatsApp.
    final whatsappUri = Uri.parse(
      'https://wa.me/$digitsOnly?text=${Uri.encodeComponent(
        'Hello, please find the student ID card PDF I am sending for printing.',
      )}',
    );

    bool opened = false;
    try {
      opened = await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      opened = false;
    }

    if (!shared && !opened) {
      _showSnack("Could not open WhatsApp. Is it installed?", isError: true);
      return false;
    }
    return true;
  }

  Future<void> _handleSendNow() async {
    if (selectedMethod.isEmpty || isSending) return;

    setState(() => isSending = true);

    bool success = false;
    if (selectedMethod == "Email") {
      success = await _sendViaEmail();
    } else if (selectedMethod == "WhatsApp") {
      success = await _sendViaWhatsApp();
    }

    if (!mounted) return;
    setState(() => isSending = false);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SendSuccessView(),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Send to Printer",
          style: TextStyle(
            color: Color(0xff038D75),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Step 3 of 3",
                        style: TextStyle(
                          color: Color(0xff038D75),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        stepCircle("1", true),
                        stepLine(),
                        stepCircle("2", true),
                        stepLine(),
                        stepCircle("3", true),
                      ],
                    ),

                    const SizedBox(height: 35),

                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: const BoxDecoration(
                          color: Color(0xffEAF7FF),
                          shape: BoxShape.circle,
                        ),
                        child: Transform.rotate(
                          angle: -math.pi / 4, // Rotate 45° upward
                          child: const Icon(
                            Icons.send_rounded,
                            size: 55,
                            color: Color(0xff038D75),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Center(
                      child: Text(
                        "Choose Delivery Method",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    deliveryCard(
                      icon: const Icon(Icons.email_outlined),
                      title: "Email",
                      subtitle: "Send ID card to printer via email",
                      value: kPrinterEmail,
                      isSelected: selectedMethod == "Email",
                      onTap: () {
                        setState(() {
                          selectedMethod = "Email";
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    deliveryCard(
                      icon: const FaIcon(FontAwesomeIcons.whatsapp),
                      iconColor: Colors.green,
                      title: "WhatsApp",
                      subtitle: "Send ID card to printer via WhatsApp",
                      value: kPrinterWhatsApp,
                      isSelected: selectedMethod == "WhatsApp",
                      onTap: () {
                        setState(() {
                          selectedMethod = "WhatsApp";
                        });
                      },
                    ),

                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xffFFF4DF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.lock_outline),
                          SizedBox(width: 18),
                          Text(
                            "ID Card image and photo \nwill be attached and shared.",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedMethod.isNotEmpty
                              ? const Color(0xff038D75)
                              : Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed:
                        selectedMethod.isNotEmpty && !isSending
                            ? _handleSendNow
                            : null,
                        child: isSending
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          "Send Now",
                          style: TextStyle(
                            fontSize: 18,
                            color: selectedMethod.isNotEmpty
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget deliveryCard({
    required Widget icon,
    required String title,
    required String subtitle,
    required String value,
    Color iconColor = const Color(0xff038D75),
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
              child: IconTheme(
                data: IconThemeData(color: iconColor, size: 40),
                child: icon,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(subtitle, style: const TextStyle(color: Colors.black54)),

                  const SizedBox(height: 8),

                  Text(value),
                ],
              ),
            ),
            const SizedBox(width: 10),

            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget stepCircle(String text, bool active) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: active ? const Color(0xff038D75) : Colors.grey.shade300,
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