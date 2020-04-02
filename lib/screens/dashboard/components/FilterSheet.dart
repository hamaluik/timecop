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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';

class FilterSheet extends StatefulWidget {
  FilterSheet({Key key}) : super(key: key);

  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  DateTime _startDate;
  DateTime _endDate;
  static DateFormat _dateFormat = DateFormat("EE, MMM d, yyyy");
  List<Project> selectedProjects = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
          ExpansionTile(
            title: Text(
              L10N.of(context).tr.filter,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w700
              )
            ),
            initiallyExpanded: true,
            children: <Widget>[
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
          ),
      ],
    );
  }
}