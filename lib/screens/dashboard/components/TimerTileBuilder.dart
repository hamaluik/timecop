import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecop/blocs/projects/projects_bloc.dart';
import 'package:timecop/blocs/settings/bloc.dart';
import 'package:timecop/blocs/work_types/bloc.dart';
import 'package:timecop/components/WorkTypeBadge.dart';
import 'package:timecop/models/WorkType.dart';
import 'package:timecop/models/timer_entry.dart';

import '../../../l10n.dart';

class TimerTileBuilder {
  final BuildContext _ctx;
  SettingsBloc _settingsBloc;
  ProjectsBloc _projectsBloc;
  WorkTypesBloc _workTypesBloc;

  TimerTileBuilder(this._ctx) {
    this._settingsBloc = BlocProvider.of<SettingsBloc>(_ctx);
    this._projectsBloc = BlocProvider.of<ProjectsBloc>(_ctx);
    this._workTypesBloc = BlocProvider.of<WorkTypesBloc>(_ctx);
  }

  static String _formatDescription(BuildContext ctx, String description) {
    if (description == null || description.trim().isEmpty) {
      return L10N.of(ctx).tr.noDescription;
    }
    return description;
  }

  static TextStyle _styleDescription(BuildContext ctx, String description) {
    if (description == null || description.trim().isEmpty) {
      return TextStyle(color: Theme.of(ctx).disabledColor);
    }
    return null;
  }

  Widget getTitleWidget(TimerEntry timerEntry) {
    String projectName;
    if (timerEntry.projectID != null) {
      projectName = _projectsBloc.getProjectByID(timerEntry.projectID)?.name;
    }

    if (_settingsBloc.state.displayProjectNameInTimer) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(projectName != null ? projectName : ""),
          if (timerEntry?.workTypeID != null) getWorkTypeBadgeWidget(timerEntry)
        ],
      );
    } else {
      return _getTimerDescriptionTextWidget(timerEntry);
    }
  }

  Widget getSubTitleWidget(TimerEntry timerEntry) {
    if (_settingsBloc.state.displayProjectNameInTimer) {
      return _getTimerDescriptionTextWidget(timerEntry);
    } else {
      return null;
    }
  }

  Widget _getTimerDescriptionTextWidget(TimerEntry timerEntry) {
    return Text(_formatDescription(_ctx, timerEntry.description),
        style: _styleDescription(_ctx, timerEntry.description));
  }

  Widget getWorkTypeBadgeWidget(TimerEntry timerEntry) {
    return WorkTypeBadge(
        workType: _workTypesBloc.getWorkTypeByID(timerEntry.workTypeID));
  }
}
