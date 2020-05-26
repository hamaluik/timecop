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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:timecop/blocs/work_types/bloc.dart';
import 'package:timecop/blocs/work_types/work_types_bloc.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/WorkType.dart';

class WorkTypeEditor extends StatefulWidget {
  final WorkType workType;

  WorkTypeEditor({Key key, @required this.workType}) : super(key: key);

  @override
  _WorkTypeEditorState createState() => _WorkTypeEditorState();
}

class _WorkTypeEditorState extends State<WorkTypeEditor> {
  TextEditingController _nameController;
  Color _colour;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workType?.name);
    _colour = widget.workType?.colour ?? Colors.grey[50];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              widget.workType == null
                  ? L10N.of(context).tr.createNewWorkType
                  : L10N.of(context).tr.editWorkType,
              style: Theme.of(context).textTheme.title,
            ),
            TextFormField(
              controller: _nameController,
              validator: (String value) => value.trim().isEmpty
                  ? L10N.of(context).tr.pleaseEnterAName
                  : null,
              decoration: InputDecoration(
                hintText: L10N.of(context).tr.workTypeName,
              ),
            ),
            MaterialColorPicker(
              selectedColor: _colour,
              shrinkWrap: true,
              onColorChange: (Color colour) => _colour = colour,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(L10N.of(context).tr.cancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text(widget.workType == null
                      ? L10N.of(context).tr.create
                      : L10N.of(context).tr.save),
                  onPressed: () async {
                    bool valid = _formKey.currentState.validate();
                    if (!valid) return;

                    final WorkTypesBloc workTypes =
                        BlocProvider.of<WorkTypesBloc>(context);
                    assert(workTypes != null);
                    if (widget.workType == null) {
                      workTypes.add(
                          CreateWorkType(_nameController.text.trim(), _colour));
                    } else {
                      WorkType w = WorkType.clone(widget.workType,
                          name: _nameController.text.trim(), colour: _colour);
                      workTypes.add(EditWorkType(w));
                    }
                    Navigator.of(context).pop();
                  },
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
