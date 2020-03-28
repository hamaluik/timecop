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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/screens/reports/components/WeekdayAverages.dart';

class ReportsScreen extends StatefulWidget {
  ReportsScreen({Key key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _startDate;
  DateTime _endDate;
  static DateFormat _dateFormat = DateFormat("EE, MMM d, yyyy");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10N.of(context).tr.reports),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Swiper(
              itemBuilder: (BuildContext context, int index){
                switch(index) {
                  case 0: return WeekdayAverages(
                    context,
                    startDate: _startDate,
                    endDate: _endDate,
                  );
                }
                return WeekdayAverages(
                  context,
                  startDate: _startDate,
                  endDate: _endDate,
                );
              },
              itemCount: 3,
              pagination: SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                  color: Theme.of(context).disabledColor,
                  activeColor: Theme.of(context).accentColor,
                )
              ),
              control: SwiperControl(iconPrevious: null, iconNext: null),
            ),
          ),
          Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.15,
            child: ListTile(
              leading: Icon(FontAwesomeIcons.calendar),
              title: Text(L10N.of(context).tr.from),
              trailing: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 18, 0),
                child: Text(_startDate == null ? "—" : _dateFormat.format(_startDate)),
              ),
              onTap: () async {
                await DatePicker.showDatePicker(
                  context,
                  currentTime: _startDate,
                  onChanged: (DateTime dt) => setState(() => _startDate = DateTime(dt.year, dt.month, dt.day)),
                  onConfirm: (DateTime dt) => setState(() => _startDate = DateTime(dt.year, dt.month, dt.day)),
                  theme: DatePickerTheme(
                    cancelStyle: Theme.of(context).textTheme.button,
                    doneStyle: Theme.of(context).textTheme.button,
                    itemStyle: Theme.of(context).textTheme.body1,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  )
                );
              },
            ),
            secondaryActions:
              _startDate == null
                ? <Widget>[]
                : <Widget>[
                  IconSlideAction(
                    color: Theme.of(context).errorColor,
                    foregroundColor: Theme.of(context).accentIconTheme.color,
                    icon: FontAwesomeIcons.minusCircle,
                    onTap: () {
                      setState(() {
                        _startDate = null;
                      });
                    },
                  )
                ],
          ),
          Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.15,
            child: ListTile(
              leading: Icon(FontAwesomeIcons.calendar),
              title: Text(L10N.of(context).tr.to),
              trailing: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 18, 0),
                child: Text(_endDate == null ? "—" : _dateFormat.format(_endDate)),
              ),
              onTap: () async {
                await DatePicker.showDatePicker(
                  context,
                  currentTime: _endDate,
                  onChanged: (DateTime dt) => setState(() => _endDate = DateTime(dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                  onConfirm: (DateTime dt) => setState(() => _endDate = DateTime(dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                  theme: DatePickerTheme(
                    cancelStyle: Theme.of(context).textTheme.button,
                    doneStyle: Theme.of(context).textTheme.button,
                    itemStyle: Theme.of(context).textTheme.body1,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  )
                );
              },
            ),
            secondaryActions:
              _endDate == null
                ? <Widget>[]
                : <Widget>[
                  IconSlideAction(
                    color: Theme.of(context).errorColor,
                    foregroundColor: Theme.of(context).accentIconTheme.color,
                    icon: FontAwesomeIcons.minusCircle,
                    onTap: () {
                      setState(() {
                        _endDate = null;
                      });
                    },
                  )
                ],
          ),
        ],
      )
    );
  }
}