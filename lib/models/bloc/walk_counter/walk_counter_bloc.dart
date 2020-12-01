import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:walking_counter/models/repositories/walk_counter_repository.dart';
import 'package:walking_counter/models/walk_counter_model.dart';

part 'walk_counter_state.dart';
part 'walk_counter_event.dart';

class WalkCounterBloc extends Bloc<WalkCounterEvent, WalkCounterState> {
  WalkCounterBloc(this._blocStepCounter, this._walkCounterRepository)
      : super(WalkCounterStateInitial(0));

  final WalkingDataStream _blocStepCounter;
  final WalkCounterRepository _walkCounterRepository;
  StreamSubscription _subscription;
  DateTime _lastStepTime;
  WalkCounterModel _lastWalkCounterModel;
  int _totalSteps;
  int _currentStepCount;

  String calculateSpeed(DateTime currentTime) {
    Duration running = Duration(milliseconds: 300);
    if (_lastStepTime == null) {
      _lastStepTime = currentTime;
      return 'Stopped';
    } else {
      final difference = currentTime.difference(_lastStepTime);
      _lastStepTime = currentTime;
      return (difference <= running) ? 'Running' : 'Walking';
    }
  }

  @override
  Stream<WalkCounterState> mapEventToState(WalkCounterEvent event) async* {
    if (event is WalkCounterEventStarted) {
      _currentStepCount = 0;
      await _subscription?.cancel();
      _subscription =
          _blocStepCounter.pedometerWalking().listen((stepModel) async {
        _lastWalkCounterModel = stepModel;
        print('Last Step: ${_lastWalkCounterModel.steps}');
        add(_WalkCounterEventPressed(
            stepModel, calculateSpeed(stepModel.timeStamp)));
        if (_lastWalkCounterModel != null) {
          print('WalkCounterEventStarted adding model to respository');
          _currentStepCount++;
          await _walkCounterRepository.insertWalkCount(_lastWalkCounterModel);
        }
      });
      yield WalkCounterStateLoading();
    }
    if (event is _WalkCounterEventPressed) {
      yield WalkCounterStateSuccess(
          _currentStepCount, event.stepCount, event.speed);
    }
    if (event is WalkCounterEventStopped) {
      if (_lastWalkCounterModel != null) {
        await _walkCounterRepository.insertWalkCount(_lastWalkCounterModel);
      }
      await _subscription.cancel();
      var results = await _walkCounterRepository.getAllData();
      print('Results $results');
      try {
        _totalSteps = results.fold(0, (value, element) {
          print('Result Fold Steps: ${element?.steps}');
          return (value + (element?.steps ?? 0));
        });
      } catch (e) {
        print('Total Steps Database Error - ${e.toString()}');
      }
      print('Total Steps from Database: $_totalSteps');
      yield WalkCounterStateInitial(_totalSteps);
    }
    if (event is WalkCounterDeleteDatabase) {
      //_currentStepCount = 0;
      await _walkCounterRepository.deleteAllData();
      yield WalkCounterStateInitial(0);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
