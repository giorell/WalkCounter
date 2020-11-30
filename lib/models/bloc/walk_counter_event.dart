part of 'walk_counter_bloc.dart';

abstract class WalkCounterEvent extends Equatable {
  const WalkCounterEvent();

  @override
  List<Object> get props => [];
}

class WalkCounterEventStarted extends WalkCounterEvent {}

class _WalkCounterEventPressed extends WalkCounterEvent {
  const _WalkCounterEventPressed(this.stepCount, this.speed);

  final WalkCounterModel stepCount;
  final String speed;

  @override
  List<Object> get props => [stepCount];
}

class WalkCounterEventStopped extends WalkCounterEvent {}

class WalkCounterDeleteDatabase extends WalkCounterEvent {}
