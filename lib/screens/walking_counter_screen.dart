import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walking_counter/models/bloc/walk_counter_bloc.dart';

class WalkingCounterScreen extends StatefulWidget {
  @override
  _WalkingCounterScreenState createState() => _WalkingCounterScreenState();
}

class _WalkingCounterScreenState extends State<WalkingCounterScreen> {
  bool _streaming = false;
  int _stepsTaken;
  String _speed;
  double _calories;
  int _stepsTotal;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalkCounterBloc, WalkCounterState>(
      listener: (context, state) {
        if (state is WalkCounterStateInitial) {
          _streaming = false;
          print('WalkCountScreen listener - _streaming is $_streaming');
        }
        if (state is WalkCounterStateLoading) {
          _streaming = true;
          print('WalkCountScreen listener - _streaming is $_streaming');
        }
      },
      builder: (context, state) {
        if (state is WalkCounterStateInitial) {
          print('State - WalkCounterStateInitial');
          _stepsTaken = 0;
          _speed = 'Stationary';
          _calories = state?.caloriesBurned ?? 0;
          _stepsTotal = state?.totalSteps ?? 0;
          return Center(
            child: _build(),
          );
        }
        if (state is WalkCounterStateLoading) {
          return _build();
        }
        if (state is WalkCounterStateSuccess) {
          print('State - WalkCounterStateSuccess');
          _stepsTaken = state.currentStepCount;
          _speed = state.speed;
          return _build();
        }
        _stepsTaken = 0;
        _speed = 'Stationary';
        _calories = 0;
        _stepsTotal = 0;
        return Center(
          child: _build(),
        );
      },
    );
  }

  Column _build() {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  'Steps Taken',
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  '$_stepsTaken',
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Steps Total',
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  '$_stepsTotal',
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
          ],
        ),
        Divider(
          height: 50,
          thickness: 0,
          color: Colors.grey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Calories',
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  '$_calories',
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
          ],
        ),
        Divider(
          height: 50,
          thickness: 0,
          color: Colors.grey,
        ),
        Center(
          child: Text(
            'Pedestrian status',
            style: TextStyle(fontSize: 25),
          ),
        ),
        getPedestrainStatusIcon(),
        Center(
          child: Text(
            _speed,
            style: _speed == 'Walking' ||
                    _speed == 'Stationary' ||
                    _speed == 'Running'
                ? TextStyle(fontSize: 25)
                : TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        _startStopButton(),
        FlatButton(
          onPressed: () {
            context.read<WalkCounterBloc>().add(WalkCounterDeleteDatabase());
          },
          child: Text('Delete Database'),
        ),
      ],
    );
  }

  Center _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Icon getPedestrainStatusIcon() {
    switch (_speed) {
      case 'Walking':
        return Icon(Icons.directions_walk, size: 50);
      case 'Stationary':
        return Icon(Icons.accessibility, size: 50);
      case 'Running':
        return Icon(Icons.directions_run, size: 50);
      default:
        return Icon(Icons.error, size: 50);
    }
  }

  RaisedButton _startStopButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
        borderRadius: new BorderRadius.circular(10.0),
      ),
      onPressed: () {
        print('WalkingCounterScreen - StartStop button pressed');
        if (!_streaming) {
          _startCounter();
        } else {
          _stopCounter();
        }
      },
      color: _streaming ? Colors.red : Colors.blue,
      textColor: Colors.white,
      child: _streaming ? Text('Stop') : Text('Start'),
      elevation: 5,
    );
  }

  void _startCounter() {
    _streaming = false;
    print('WalkingCounterScreen - Start pressed');
    context.read<WalkCounterBloc>().add(WalkCounterEventStarted());
  }

  void _stopCounter() {
    _streaming = false;
    print('WalkingCounterScreen - Stop pressed');
    context.read<WalkCounterBloc>().add(WalkCounterEventStopped());
  }
}
