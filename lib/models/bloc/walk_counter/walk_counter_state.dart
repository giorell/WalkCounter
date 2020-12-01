part of 'walk_counter_bloc.dart';

abstract class WalkCounterState extends Equatable {
  const WalkCounterState();

  @override
  List<Object> get props => [];
}

/// The initial state of the [WalkCounterBloc].
class WalkCounterStateInitial extends WalkCounterState {
  const WalkCounterStateInitial(this.totalSteps);
  final int totalSteps;
  double get caloriesBurned {
    final caloriesBurnedPerStep = 0.4;
    final double calories = totalSteps * caloriesBurnedPerStep;
    return double.parse(calories.toStringAsFixed(1));
  }

  @override
  List<Object> get props => [totalSteps];
}

class WalkCounterStateSuccess extends WalkCounterState {
  const WalkCounterStateSuccess(
      this.currentStepCount, this.stepModel, this.speed);

  /// The current step count.
  final int currentStepCount;
  final WalkCounterModel stepModel;
  final String speed;

  @override
  List<Object> get props => [stepModel];
}

class WalkCounterStateLoading extends WalkCounterState {}
