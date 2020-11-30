import 'dart:async';
import 'dart:math';
import 'package:pedometer/pedometer.dart';

abstract class WalkingDataStream {
  Stream<WalkCounterModel> pedometerWalking();
}

class PedometerStream implements WalkingDataStream {
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;

  @override
  Stream<WalkCounterModel> pedometerWalking() {
    StreamController<WalkCounterModel> _controller;

    void onStepCount(StepCount event) {
      print('StepCount - ${event.steps}');
      final time = event.timeStamp;
      final walkModel = WalkCounterModel(time.millisecondsSinceEpoch, 1, time);
      _controller.add(walkModel);
    }

    void onPedestrianStatusChanged(PedestrianStatus event) {
      print(event);
      //TODO: Need to figure out how to improve accuracy
      // print('Pedestrian Event - ${event.status}');
      // if (event.status == 'walking') {
      //   final _steps = 1;
      //   final time = event.timeStamp;
      //   final walkModel =
      //       WalkCounterModel(time.millisecondsSinceEpoch, _steps, time);
      //   _controller.add(walkModel);
      // } else {
      //   return;
      // }
    }

    void onPedestrianStatusError(error) {
      print('onPedestrianStatusError: $error');
      _controller.addError(error.toString());
    }

    void onStepCountError(error) {
      _controller.addError(error.toString());
    }

    void stopStream() {
      _pedestrianStatusStream.listen((event) {}).cancel();
      _stepCountStream.listen((event) {}).cancel();
      _controller.close();
    }

    void startStream() {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);

      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    }

    _controller = StreamController<WalkCounterModel>(
        onListen: startStream,
        onPause: stopStream,
        onResume: startStream,
        onCancel: stopStream);

    return _controller.stream;
  }
}

class WalkCounterStream implements WalkingDataStream {
  Duration walking = Duration(milliseconds: 700);
  Duration running = Duration(milliseconds: 200);

  Duration walkOrRun() {
    Random random = new Random();
    int randomNumber = random.nextInt(2);
    return randomNumber == 1 ? walking : running;
  }

  @override
  Stream<WalkCounterModel> pedometerWalking() {
    StreamController<WalkCounterModel> _controller;
    int maxCount = 1000;
    Timer timer;
    int stepCounter = 0;

    void tick(_) {
      stepCounter++;
      final time = DateTime.now();
      final walkModel =
          WalkCounterModel(time.millisecondsSinceEpoch, stepCounter, time);
      _controller.add(walkModel);
      if (stepCounter == maxCount) {
        timer.cancel();
        _controller.close();
      }
    }

    void startTimer() {
      timer = Timer.periodic(walkOrRun(), tick);
    }

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
    }

    _controller = StreamController<WalkCounterModel>(
        onListen: startTimer,
        onPause: stopTimer,
        onResume: startTimer,
        onCancel: stopTimer);

    return _controller.stream;
  }
}

class WalkCounterModel extends WalkCounterStream {
  WalkCounterModel(this.id, this.steps, this.timeStamp)
      : assert(id != null),
        assert(steps != null),
        assert(timeStamp != null);

  int id;
  int steps;
  DateTime timeStamp;

  factory WalkCounterModel.fromJson(Map<String, dynamic> data) {
    return WalkCounterModel(
        data['id'], data['steps'], DateTime.parse(data['timeStamp']));
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "steps": this.steps,
        "timeStamp": this.timeStamp.toIso8601String(),
      };
}
