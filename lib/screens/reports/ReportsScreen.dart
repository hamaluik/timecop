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

class ReportsScreen extends StatefulWidget {
  ReportsScreen({Key key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final TimersBloc timers = BlocProvider.of<TimersBloc>(context);

    /*List<BarChartGroupData> days = [];
    for(int weekday = 1; weekday <= 7; weekday++) {
      days.add(
        BarChartGroupData(
          x: weekday,
          barRods: <BarChartRodData>[
            BarChartRodData(
              y: daySums[weekday - 1]
            ),
          ]
        )
      );
    }*/

    return Scaffold(
      appBar: AppBar(
        title: Text(L10N.of(context).tr.reports),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Card(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
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
                                    return 'M';
                                  case 1:
                                    return 'T';
                                  case 2:
                                    return 'W';
                                  case 3:
                                    return 'T';
                                  case 4:
                                    return 'F';
                                  case 5:
                                    return 'S';
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
                                  y: timers.state.timers
                                      .where((t) => t.endTime != null)
                                      .where((t) {
                                        switch(day) {
                                          case 0:
                                            return t.startTime.weekday == 7;
                                          default:
                                            return t.startTime.weekday == day + 1;
                                        }
                                      })
                                      .map((t) => t.endTime.difference(t.startTime).inSeconds.toDouble() / 3600)
                                      .fold(0.0, (double a, double e) => a + e)
                                )
                              ]
                            ))
                            .toList()
                        )
                      ),
                    ),
                    Container(height: 16,),
                    Text("Hours Per Day of Week", style: Theme.of(context).textTheme.title, textAlign: TextAlign.center,),
                  ],
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}