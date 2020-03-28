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

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/timers/bloc.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/timer_entry.dart';

class WeekdayAverages extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final List<double> _daysData;

  static List<double> calculateData(BuildContext context, DateTime startDate, DateTime endDate) {
    final TimersBloc timers = BlocProvider.of<TimersBloc>(context);

    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime(1970);
    List<double> daySums = <double>[0, 0, 0, 0, 0, 0, 0];
    for(
      TimerEntry timer in timers.state.timers
        .where((timer) => timer.endTime != null)
        .where((timer) => startDate != null ? timer.startTime.isAfter(startDate) : true)
        .where((timer) => endDate != null ? timer.startTime.isBefore(endDate) : true)
    ) {
      double hours = timer.endTime.difference(timer.startTime).inSeconds.toDouble() / 3600.0;
      int weekday = timer.startTime.weekday;
      if(weekday == 7) weekday = 0;
      daySums[weekday] += hours;
      if(timer.startTime.isBefore(firstDate)) {
        firstDate = timer.startTime;
      }
      if(timer.startTime.isAfter(lastDate)) {
        lastDate = timer.startTime;
      }
    }
    int totalDays = DateTime(lastDate.year, lastDate.month, lastDate.day)
      .difference(DateTime(firstDate.year, firstDate.month, firstDate.day))
      .inDays;
    if(totalDays > 0) {
      for(int i = 0; i < 7; i++) {
        daySums[i] /= totalDays.toDouble();
      }
    }

    return daySums;
  }

  WeekdayAverages(BuildContext context, {Key key, @required this.startDate, @required this.endDate})
    : this._daysData = calculateData(context, startDate, endDate),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    fitInsideTheChart: true,
                    tooltipBgColor: Theme.of(context).cardColor,
                    getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex)
                        => BarTooltipItem(
                          L10N.of(context).tr.nHours(rod.y.toStringAsFixed(1)),
                          Theme.of(context).textTheme.body1
                        )
                  )
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: FlGridData(
                  show: true,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: SideTitles(
                    showTitles: true,
                    textStyle: Theme.of(context).textTheme.body1,
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    textStyle: Theme.of(context).textTheme.body1,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'S';
                        case 1:
                          return 'M';
                        case 2:
                          return 'T';
                        case 3:
                          return 'W';
                        case 4:
                          return 'T';
                        case 5:
                          return 'F';
                        case 6:
                          return 'S';
                        default:
                          return '';
                      }
                    }
                  )
                ),
                barGroups: List.generate(7, (i) => i)
                  .map((day) => BarChartGroupData(
                    x: day,
                    barRods: <BarChartRodData>[
                      BarChartRodData(
                        color: Theme.of(context).accentColor,
                        width: 22,
                        y: _daysData[day],
                      )
                    ]
                  ))
                  .toList()
              )
            ),
          ),
          Container(height: 16,),
          Text(L10N.of(context).tr.averageDailyHours, style: Theme.of(context).textTheme.title, textAlign: TextAlign.center,),
        ],
      )
    );
  }
}