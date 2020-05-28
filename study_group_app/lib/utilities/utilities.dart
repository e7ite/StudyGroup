export 'style.dart';
export 'loading.dart';
export 'widgets.dart';
export 'validations.dart';

import 'package:flutter/material.dart';

class Utility {
  static TimeOfDay strToTimeOfDay(String time) {
    var formatTime = time.split(':');
    return TimeOfDay(
        hour: int.parse(formatTime[0]), minute: int.parse(formatTime[1]));
  }
}
