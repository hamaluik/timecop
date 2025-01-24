// Copyright 2020 Kenton Hamaluik
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:timecop/l10n.dart';

enum FilterPreset {
  thisWeek,
  thisMonth,
  lastMonth,
  lastXDays;

  DateTime getStartDate(int firstDayOfWeekIndex, int defaultFilterDays) {
    final now = DateTime.now();
    switch (this) {
      case FilterPreset.thisWeek:
        var durationDiff = now.weekday - firstDayOfWeekIndex;
        if (durationDiff < 0) durationDiff += 7;
        return now.subtract(Duration(days: durationDiff)).copyWith(
            hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      case FilterPreset.thisMonth:
        return DateTime(now.year, now.month, 1);
      case FilterPreset.lastMonth:
        return DateTime(now.year, now.month - 1, 1);
      case FilterPreset.lastXDays:
        final xDaysAgo =
            DateTime.now().subtract(Duration(days: defaultFilterDays));
        return DateTime(xDaysAgo.year, xDaysAgo.month, xDaysAgo.day);
    }
  }

  DateTime? getEndDate() {
    final now = DateTime.now();
    switch (this) {
      case FilterPreset.thisWeek:
        return null;
      case FilterPreset.thisMonth:
        return DateTime(now.year, now.month + 1, 1)
            .subtract(const Duration(seconds: 1));
      case FilterPreset.lastMonth:
        return DateTime(now.year, now.month, 1)
            .subtract(const Duration(seconds: 1));
      case FilterPreset.lastXDays:
        return null;
    }
  }

  String display(BuildContext context, int defaultFilterDays) {
    switch (this) {
      case FilterPreset.thisWeek:
        return L10N.of(context).tr.thisWeek;
      case FilterPreset.thisMonth:
        return L10N.of(context).tr.thisMonth;
      case FilterPreset.lastMonth:
        return L10N.of(context).tr.lastMonth;
      case FilterPreset.lastXDays:
        return L10N.of(context).tr.lastXDays(defaultFilterDays);
    }
  }
}
