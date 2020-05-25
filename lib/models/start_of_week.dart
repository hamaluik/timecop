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

extension StartOfWeek on DateTime {
  DateTime startOfWeek({int startOfWeekDay = DateTime.sunday}) {
    // change to Sunday as start..
    int diff = (7 + (this.weekday - startOfWeekDay)) % 7;
    DateTime dt = this.add(Duration(days: -diff));
    return DateTime(dt.year, dt.month, dt.day);
  }
}
