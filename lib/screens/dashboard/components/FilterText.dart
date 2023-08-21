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
import 'package:intl/intl.dart';
import 'package:timecop/l10n.dart';

class FilterText extends StatelessWidget {
  final DateTime? filterStart;
  final DateTime? filterEnd;
  const FilterText({Key? key, this.filterStart, this.filterEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();

    if (filterStart == null && filterEnd == null) return const SizedBox();

    final filterString = (filterStart == null)
        ? L10N.of(context).tr.filterUntil(dateFormat.format(filterEnd!))
        : (filterEnd == null)
            ? L10N.of(context).tr.filterFrom(dateFormat.format(filterStart!))
            : L10N.of(context).tr.filterFromUntil(
                dateFormat.format(filterStart!), dateFormat.format(filterEnd!));

    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Center(
            child: Text(
          filterString,
          style: Theme.of(context).textTheme.bodySmall,
        )));
  }
}
