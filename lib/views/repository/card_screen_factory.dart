import 'package:flutter/material.dart';

import '../card_preview/deli_preview_card_view.dart';
import '../card_preview/preview_card_screen.dart';


class CardScreenFactory {
  static Widget getScreen(
      String schoolName,
      Map<String, dynamic> studentData,
      ) {
    switch (schoolName) {
      case "Delhi Public School":
        return DeliPreviewCardView(
          studentData: studentData,
        );

      case "ABC School":
        return PreviewCardScreen(
          studentData: studentData,
        );

      default:
        return PreviewCardScreen(
          studentData: studentData,
        );
    }
  }
}