import 'package:flutter/material.dart';
import 'package:school_id_collect/views/card_preview/deli_preview_card_view.dart';
import 'package:school_id_collect/views/card_preview/preview_card_screen.dart';
import 'package:school_id_collect/views/card_send/send_card_view.dart';
import 'package:school_id_collect/views/card_send/send_success_view.dart';
import 'package:school_id_collect/views/select_school/select_school_view.dart';
import 'package:school_id_collect/views/splash/slider_splash_view.dart';
import 'package:school_id_collect/views/splash/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student ID Card',
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
