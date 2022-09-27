import 'package:flutter/material.dart';
import 'package:timecop/l10n.dart';

class TimerUtils {
  static String formatDescription(BuildContext context, String? description) {
    if (description == null || description.trim().isEmpty) {
      return L10N.of(context).tr.noDescription;
    }
    return description;
  }

  static TextStyle styleDescription(BuildContext context, String? description) {
    if (description == null || description.trim().isEmpty) {
      return TextStyle(color: Theme.of(context).disabledColor);
    } else {
      return TextStyle(color: Theme.of(context).colorScheme.onBackground);
    }
  }
}
