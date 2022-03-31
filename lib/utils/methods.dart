import 'package:flutter/material.dart';

class Methods {
  static var hour = DateTime.now().hour;
  static String greeting() {
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  static Widget greetingIcon() {
    if (hour < 12) {
      return Icon(
        Icons.cloud,
        color: Colors.white.withOpacity(0.6),
        size: 15,
      );
    }
    if (hour < 17) {
      return Icon(
        Icons.sunny,
        color: Colors.yellow.withOpacity(0.6),
        size: 15,
      );
    }
    return Icon(
      Icons.mode_night,
      color: Colors.white.withOpacity(0.6),
      size: 15,
    );
  }
}
