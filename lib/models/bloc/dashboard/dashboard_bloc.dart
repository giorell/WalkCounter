import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:walking_counter/models/repositories/walk_counter_repository.dart';

import '../../dummy_dashboard_data.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._walkCounterRepository) : super(DashboardInitial());
  final WalkCounterRepository _walkCounterRepository;
  double _totalSteps;
  var _dummyData = DummyDashboardData();

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is DashboardEventInitial) {
      final result = await _getStepData();
      List<BarChartGroupData> _stepsTodayBarData = [];
      _stepsTodayBarData.add(result);
      yield DashboardLoadDataState(_stepsTodayBarData);
      print('DashboardBloc - yield LoadDataState');
    }
  }

  Future _getStepData() async {
    var results = await _walkCounterRepository.getAllData();
    try {
      _totalSteps = results.fold(0, (value, element) {
        return (value + (element?.steps ?? 0));
      });
    } catch (e) {
      print('Total Steps Database Error - ${e.toString()}');
    }
    print(_totalSteps);
    var data = _dummyData.makeGroupData(1, _totalSteps, _totalSteps * 0.4, 20);
    return data;
  }
}
